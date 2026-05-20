package models

import "time"

// Booking represents a confirmed room booking.
type Booking struct {
	ID          string    `json:"id" db:"id"`
	UserID      string    `json:"user_id" db:"user_id"`
	RoomID      string    `json:"room_id" db:"room_id"`
	BookingDate string    `json:"booking_date" db:"booking_date"` // YYYY-MM-DD
	StartTime   string    `json:"start_time" db:"start_time"`     // HH:MM
	EndTime     string    `json:"end_time" db:"end_time"`         // HH:MM
	Status      string    `json:"status" db:"status"`             // upcoming, completed, cancelled
	Verified    bool      `json:"verified" db:"verified"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

// BookingWithRoom includes room details for the booking.
type BookingWithRoom struct {
	Booking
	RoomName     string  `json:"room_name" db:"room_name"`
	RoomType     string  `json:"room_type" db:"room_type"`
	RoomLocation string  `json:"room_location" db:"room_location"`
	RoomImageURL *string `json:"room_image_url,omitempty" db:"room_image_url"`
}

// CreateBookingRequest is the payload to create a booking.
type CreateBookingRequest struct {
	RoomID    string `json:"room_id" binding:"required"`
	Date      string `json:"date" binding:"required"`       // YYYY-MM-DD
	StartTime string `json:"start_time" binding:"required"` // HH:MM
	EndTime   string `json:"end_time" binding:"required"`   // HH:MM
}

// UpdateBookingRequest is the payload to modify a booking.
type UpdateBookingRequest struct {
	Date      string `json:"date,omitempty"`
	StartTime string `json:"start_time,omitempty"`
	EndTime   string `json:"end_time,omitempty"`
}

// BookingFilter contains query parameters for filtering bookings.
type BookingFilter struct {
	Status string `form:"status"` // upcoming, completed, cancelled
	Date   string `form:"date"`   // YYYY-MM-DD
}

// OTPRequest represents an OTP send/verify request.
type OTPRequest struct {
	Email string `json:"email" binding:"required,email"`
}

// OTPVerifyRequest is used to verify an OTP code.
type OTPVerifyRequest struct {
	Email string `json:"email" binding:"required,email"`
	Code  string `json:"code" binding:"required,len=6"`
}
