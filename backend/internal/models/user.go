package models

import "time"

// User represents a registered app user.
type User struct {
	ID           string    `json:"id" db:"id"`
	Username     string    `json:"username" db:"username"`
	Email        string    `json:"email" db:"email"`
	PasswordHash string    `json:"-" db:"password_hash"`
	AvatarURL    *string   `json:"avatar_url,omitempty" db:"avatar_url"`
	GoogleID     *string   `json:"-" db:"google_id"`
	CreatedAt    time.Time `json:"created_at" db:"created_at"`
}

// UserResponse is the safe response (no password hash).
type UserResponse struct {
	ID        string    `json:"id"`
	Username  string    `json:"username"`
	Email     string    `json:"email"`
	AvatarURL *string   `json:"avatar_url,omitempty"`
	CreatedAt time.Time `json:"created_at"`
}

// ToResponse converts User to UserResponse.
func (u *User) ToResponse() UserResponse {
	return UserResponse{
		ID:        u.ID,
		Username:  u.Username,
		Email:     u.Email,
		AvatarURL: u.AvatarURL,
		CreatedAt: u.CreatedAt,
	}
}

// LoginRequest is the login payload.
type LoginRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

// RegisterRequest is the registration payload.
type RegisterRequest struct {
	Username string `json:"username" binding:"required,min=3,max=50"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

// GoogleLoginRequest is the Google OAuth payload.
type GoogleLoginRequest struct {
	Token string `json:"token" binding:"required"`
}

// AuthResponse is returned after successful authentication.
type AuthResponse struct {
	AccessToken  string       `json:"access_token"`
	RefreshToken string       `json:"refresh_token"`
	User         UserResponse `json:"user"`
}
