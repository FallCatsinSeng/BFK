package main

import (
	"log"
	"os"

	"github.com/FallCatsinSeng/BFK/backend/internal/config"
	"github.com/FallCatsinSeng/BFK/backend/internal/database"
	"github.com/FallCatsinSeng/BFK/backend/internal/handlers"
	"github.com/FallCatsinSeng/BFK/backend/internal/middleware"
	"github.com/FallCatsinSeng/BFK/backend/internal/repository"
	"github.com/FallCatsinSeng/BFK/backend/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Load .env file (optional in production)
	_ = godotenv.Load()

	// Load configuration
	cfg := config.Load()

	// Connect to database
	db, err := database.Connect(cfg)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	// Run migrations
	if err := database.RunMigrations(db); err != nil {
		log.Fatalf("Failed to run migrations: %v", err)
	}

	// Seed initial data
	if err := database.SeedData(db); err != nil {
		log.Printf("Warning: seed data error (may already exist): %v", err)
	}

	// Initialize repositories
	userRepo := repository.NewUserRepository(db)
	roomRepo := repository.NewRoomRepository(db)
	bookingRepo := repository.NewBookingRepository(db)

	// Initialize services
	otpService := services.NewOTPService(cfg)
	authService := services.NewAuthService(cfg, userRepo, otpService)

	// Initialize handlers
	authHandler := handlers.NewAuthHandler(authService, otpService)
	roomHandler := handlers.NewRoomHandler(roomRepo)
	bookingHandler := handlers.NewBookingHandler(bookingRepo, roomRepo)

	// Setup Gin router
	router := gin.Default()

	// Global middleware
	router.Use(middleware.CORSMiddleware())

	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "service": "bfk-room-booking"})
	})

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		// Auth routes (public)
		auth := v1.Group("/auth")
		{
			auth.POST("/login", authHandler.Login)
			auth.POST("/register", authHandler.Register)
			auth.POST("/google", authHandler.GoogleLogin)
			auth.POST("/otp/send", authHandler.SendOTP)
			auth.POST("/otp/verify", authHandler.VerifyOTP)
			auth.POST("/refresh", authHandler.RefreshToken)
		}

		// Protected routes
		protected := v1.Group("")
		protected.Use(middleware.AuthMiddleware(cfg.JWTSecret))
		{
			// User
			protected.GET("/users/me", authHandler.GetCurrentUser)

			// Rooms
			protected.GET("/rooms", roomHandler.ListRooms)
			protected.GET("/rooms/:id", roomHandler.GetRoom)
			protected.GET("/rooms/categories", roomHandler.GetCategories)

			// Bookings
			protected.GET("/bookings", bookingHandler.ListBookings)
			protected.POST("/bookings", bookingHandler.CreateBooking)
			protected.GET("/bookings/:id", bookingHandler.GetBooking)
			protected.PUT("/bookings/:id", bookingHandler.UpdateBooking)
			protected.DELETE("/bookings/:id", bookingHandler.CancelBooking)

			// Calendar
			protected.GET("/calendar/:year/:month", roomHandler.GetCalendarAvailability)

			// Face verify
			protected.POST("/auth/face-verify", authHandler.FaceVerify)
		}
	}

	// Start server
	port := cfg.Port
	if port == "" {
		port = "8080"
	}
	log.Printf("Server starting on port %s", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
		os.Exit(1)
	}
}
