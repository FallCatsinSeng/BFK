package handlers

import (
	"net/http"

	"github.com/FallCatsinSeng/BFK/backend/internal/models"
	"github.com/FallCatsinSeng/BFK/backend/internal/repository"
	"github.com/gin-gonic/gin"
)

// BookingHandler handles booking-related endpoints.
type BookingHandler struct {
	bookingRepo *repository.BookingRepository
	roomRepo    *repository.RoomRepository
}

// NewBookingHandler creates a new BookingHandler.
func NewBookingHandler(bookingRepo *repository.BookingRepository, roomRepo *repository.RoomRepository) *BookingHandler {
	return &BookingHandler{
		bookingRepo: bookingRepo,
		roomRepo:    roomRepo,
	}
}

// ListBookings returns all bookings for the authenticated user.
// GET /api/v1/bookings?status=upcoming&date=2026-04-27
func (h *BookingHandler) ListBookings(c *gin.Context) {
	userID, _ := c.Get("userID")

	var filter models.BookingFilter
	if err := c.ShouldBindQuery(&filter); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid query parameters"})
		return
	}

	bookings, err := h.bookingRepo.FindByUser(userID.(string), filter)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch bookings"})
		return
	}

	if bookings == nil {
		bookings = []models.BookingWithRoom{}
	}

	c.JSON(http.StatusOK, gin.H{
		"bookings": bookings,
		"total":    len(bookings),
	})
}

// CreateBooking creates a new room booking.
// POST /api/v1/bookings
func (h *BookingHandler) CreateBooking(c *gin.Context) {
	userID, _ := c.Get("userID")

	var req models.CreateBookingRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request: " + err.Error()})
		return
	}

	// Verify room exists
	_, err := h.roomRepo.FindByID(req.RoomID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room not found"})
		return
	}

	// Check slot availability
	available, err := h.bookingRepo.IsSlotAvailable(req.RoomID, req.Date, req.StartTime)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check availability"})
		return
	}
	if !available {
		c.JSON(http.StatusConflict, gin.H{"error": "This time slot is already booked"})
		return
	}

	// Create booking
	booking := &models.Booking{
		UserID:      userID.(string),
		RoomID:      req.RoomID,
		BookingDate: req.Date,
		StartTime:   req.StartTime,
		EndTime:     req.EndTime,
		Status:      "upcoming",
	}

	if err := h.bookingRepo.Create(booking); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create booking"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Booking created successfully",
		"booking": booking,
	})
}

// GetBooking returns a single booking by ID.
// GET /api/v1/bookings/:id
func (h *BookingHandler) GetBooking(c *gin.Context) {
	id := c.Param("id")
	userID, _ := c.Get("userID")

	booking, err := h.bookingRepo.FindByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Booking not found"})
		return
	}

	// Ensure user owns this booking
	if booking.UserID != userID.(string) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	c.JSON(http.StatusOK, booking)
}

// UpdateBooking modifies a booking's date/time (fix booking).
// PUT /api/v1/bookings/:id
func (h *BookingHandler) UpdateBooking(c *gin.Context) {
	id := c.Param("id")
	userID, _ := c.Get("userID")

	// Verify ownership
	booking, err := h.bookingRepo.FindByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Booking not found"})
		return
	}
	if booking.UserID != userID.(string) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	var req models.UpdateBookingRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request: " + err.Error()})
		return
	}

	// If changing time, check availability
	if req.StartTime != "" && req.Date != "" {
		available, err := h.bookingRepo.IsSlotAvailable(booking.RoomID, req.Date, req.StartTime)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check availability"})
			return
		}
		if !available {
			c.JSON(http.StatusConflict, gin.H{"error": "This time slot is already booked"})
			return
		}
	}

	if err := h.bookingRepo.Update(id, req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update booking"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Booking updated successfully"})
}

// CancelBooking cancels a booking.
// DELETE /api/v1/bookings/:id
func (h *BookingHandler) CancelBooking(c *gin.Context) {
	id := c.Param("id")
	userID, _ := c.Get("userID")

	// Verify ownership
	booking, err := h.bookingRepo.FindByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Booking not found"})
		return
	}
	if booking.UserID != userID.(string) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	if err := h.bookingRepo.Cancel(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to cancel booking"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Booking cancelled successfully"})
}
