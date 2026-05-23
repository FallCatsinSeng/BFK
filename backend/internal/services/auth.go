package services

import (
	"errors"

	"github.com/FallCatsinSeng/BFK/backend/internal/config"
	"github.com/FallCatsinSeng/BFK/backend/internal/models"
	"github.com/FallCatsinSeng/BFK/backend/internal/repository"
	jwtPkg "github.com/FallCatsinSeng/BFK/backend/pkg/jwt"
	"golang.org/x/crypto/bcrypt"
)

// AuthService handles authentication logic.
type AuthService struct {
	cfg        *config.Config
	userRepo   *repository.UserRepository
	otpService *OTPService
}

// NewAuthService creates a new AuthService.
func NewAuthService(cfg *config.Config, userRepo *repository.UserRepository, otpService *OTPService) *AuthService {
	return &AuthService{
		cfg:        cfg,
		userRepo:   userRepo,
		otpService: otpService,
	}
}

// Login authenticates a user with username and password.
func (s *AuthService) Login(username, password string) (*models.AuthResponse, error) {
	user, err := s.userRepo.FindByUsername(username)
	if err != nil {
		return nil, errors.New("invalid credentials")
	}

	// Verify password
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password)); err != nil {
		return nil, errors.New("invalid credentials")
	}

	return s.generateTokenResponse(user)
}

// Register creates a new user and returns tokens.
func (s *AuthService) Register(req models.RegisterRequest) (*models.AuthResponse, error) {
	// Check if username already exists
	if _, err := s.userRepo.FindByUsername(req.Username); err == nil {
		return nil, errors.New("username already taken")
	}

	// Check if email already exists
	if _, err := s.userRepo.FindByEmail(req.Email); err == nil {
		return nil, errors.New("email already registered")
	}

	// Hash password
	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, errors.New("failed to hash password")
	}

	user := &models.User{
		Username:     req.Username,
		Email:        req.Email,
		PasswordHash: string(hash),
	}

	if err := s.userRepo.Create(user); err != nil {
		return nil, errors.New("failed to create user")
	}

	return s.generateTokenResponse(user)
}

// GoogleLogin handles Google OAuth authentication.
func (s *AuthService) GoogleLogin(token string) (*models.AuthResponse, error) {
	// In production, verify the Google token with Google's API
	// For now, we create/find a user based on the token as a placeholder
	// This would typically decode the Google ID token to get user info

	// Placeholder: treat token as a Google ID
	user, err := s.userRepo.FindByGoogleID(token)
	if err != nil {
		// Create new user from Google data
		user = &models.User{
			Username: "google_user_" + token[:8],
			Email:    token[:8] + "@gmail.com",
		}
		googleID := token
		user.GoogleID = &googleID
		if err := s.userRepo.Create(user); err != nil {
			return nil, errors.New("failed to create user from Google")
		}
	}

	return s.generateTokenResponse(user)
}

// RefreshToken generates new tokens from a refresh token.
func (s *AuthService) RefreshToken(refreshToken string) (*models.AuthResponse, error) {
	claims, err := jwtPkg.ValidateToken(refreshToken, s.cfg.JWTSecret)
	if err != nil {
		return nil, errors.New("invalid refresh token")
	}

	user, err := s.userRepo.FindByID(claims.UserID)
	if err != nil {
		return nil, errors.New("user not found")
	}

	return s.generateTokenResponse(user)
}

// GetUser retrieves a user by ID.
func (s *AuthService) GetUser(userID string) (*models.User, error) {
	return s.userRepo.FindByID(userID)
}

// generateTokenResponse creates access + refresh tokens and builds the response.
func (s *AuthService) generateTokenResponse(user *models.User) (*models.AuthResponse, error) {
	accessToken, err := jwtPkg.GenerateAccessToken(user.ID, user.Email, s.cfg.JWTSecret)
	if err != nil {
		return nil, errors.New("failed to generate access token")
	}

	refreshToken, err := jwtPkg.GenerateRefreshToken(user.ID, user.Email, s.cfg.JWTSecret)
	if err != nil {
		return nil, errors.New("failed to generate refresh token")
	}

	return &models.AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         user.ToResponse(),
	}, nil
}
