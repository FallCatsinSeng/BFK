package models

import "time"

// Room represents a bookable room/space.
type Room struct {
	ID          string    `json:"id" db:"id"`
	Name        string    `json:"name" db:"name"`
	Type        string    `json:"type" db:"type"` // room, lab, auditorium
	Description string    `json:"description" db:"description"`
	Location    string    `json:"location" db:"location"`
	ImageURL    *string   `json:"image_url,omitempty" db:"image_url"`
	Capacity    int       `json:"capacity" db:"capacity"`
	HasAC       bool      `json:"has_ac" db:"has_ac"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

// RoomWithStatus includes computed availability status.
type RoomWithStatus struct {
	Room
	Status   string `json:"status"` // "available" or "booked"
	TimeSlot string `json:"time_slot,omitempty"`
}

// RoomFilter contains query parameters for filtering rooms.
type RoomFilter struct {
	Type string `form:"type"`
	Date string `form:"date"` // format: 2026-04-27
}

// TimeSlot represents an available or booked time range.
type TimeSlot struct {
	ID        string `json:"id" db:"id"`
	RoomID    string `json:"room_id" db:"room_id"`
	StartTime string `json:"start_time" db:"start_time"`
	EndTime   string `json:"end_time" db:"end_time"`
	DayOfWeek *int   `json:"day_of_week,omitempty" db:"day_of_week"`
}

// CalendarDay represents room availability for one day.
type CalendarDay struct {
	Date           string `json:"date"`
	Day            int    `json:"day"`
	IsAvailable    bool   `json:"is_available"`
	BookingsCount  int    `json:"bookings_count"`
	TotalSlots     int    `json:"total_slots"`
}

// CalendarResponse is the response for calendar availability endpoint.
type CalendarResponse struct {
	Year  int           `json:"year"`
	Month int           `json:"month"`
	Days  []CalendarDay `json:"days"`
}
