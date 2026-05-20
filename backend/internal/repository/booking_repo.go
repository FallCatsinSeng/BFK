package repository

import (
	"database/sql"
	"fmt"

	"github.com/FallCatsinSeng/BFK/backend/internal/models"
)

// BookingRepository handles booking database operations.
type BookingRepository struct {
	db *sql.DB
}

// NewBookingRepository creates a new BookingRepository.
func NewBookingRepository(db *sql.DB) *BookingRepository {
	return &BookingRepository{db: db}
}

// Create inserts a new booking.
func (r *BookingRepository) Create(booking *models.Booking) error {
	return r.db.QueryRow(`
		INSERT INTO bookings (user_id, room_id, booking_date, start_time, end_time, status)
		VALUES ($1, $2, $3, $4, $5, $6)
		RETURNING id, created_at`,
		booking.UserID, booking.RoomID, booking.BookingDate,
		booking.StartTime, booking.EndTime, booking.Status,
	).Scan(&booking.ID, &booking.CreatedAt)
}

// FindByID retrieves a booking by ID.
func (r *BookingRepository) FindByID(id string) (*models.BookingWithRoom, error) {
	booking := &models.BookingWithRoom{}
	err := r.db.QueryRow(`
		SELECT b.id, b.user_id, b.room_id, b.booking_date, b.start_time, b.end_time,
			   b.status, b.verified, b.created_at,
			   r.name, r.type, r.location, r.image_url
		FROM bookings b
		JOIN rooms r ON r.id = b.room_id
		WHERE b.id = $1`, id,
	).Scan(&booking.ID, &booking.UserID, &booking.RoomID, &booking.BookingDate,
		&booking.StartTime, &booking.EndTime, &booking.Status, &booking.Verified,
		&booking.CreatedAt, &booking.RoomName, &booking.RoomType,
		&booking.RoomLocation, &booking.RoomImageURL)
	if err != nil {
		return nil, err
	}
	return booking, nil
}

// FindByUser retrieves all bookings for a user with optional filters.
func (r *BookingRepository) FindByUser(userID string, filter models.BookingFilter) ([]models.BookingWithRoom, error) {
	query := `
		SELECT b.id, b.user_id, b.room_id, b.booking_date, b.start_time, b.end_time,
			   b.status, b.verified, b.created_at,
			   r.name, r.type, r.location, r.image_url
		FROM bookings b
		JOIN rooms r ON r.id = b.room_id
		WHERE b.user_id = $1`
	args := []interface{}{userID}
	argIdx := 2

	if filter.Status != "" {
		query += fmt.Sprintf(" AND b.status = $%d", argIdx)
		args = append(args, filter.Status)
		argIdx++
	}

	if filter.Date != "" {
		query += fmt.Sprintf(" AND b.booking_date = $%d", argIdx)
		args = append(args, filter.Date)
		argIdx++
	}

	query += " ORDER BY b.booking_date DESC, b.start_time ASC"

	rows, err := r.db.Query(query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var bookings []models.BookingWithRoom
	for rows.Next() {
		var b models.BookingWithRoom
		err := rows.Scan(&b.ID, &b.UserID, &b.RoomID, &b.BookingDate,
			&b.StartTime, &b.EndTime, &b.Status, &b.Verified, &b.CreatedAt,
			&b.RoomName, &b.RoomType, &b.RoomLocation, &b.RoomImageURL)
		if err != nil {
			return nil, err
		}
		bookings = append(bookings, b)
	}
	return bookings, nil
}

// Update modifies a booking's date/time.
func (r *BookingRepository) Update(id string, req models.UpdateBookingRequest) error {
	setClauses := ""
	args := []interface{}{}
	argIdx := 1

	if req.Date != "" {
		setClauses += fmt.Sprintf("booking_date = $%d, ", argIdx)
		args = append(args, req.Date)
		argIdx++
	}
	if req.StartTime != "" {
		setClauses += fmt.Sprintf("start_time = $%d, ", argIdx)
		args = append(args, req.StartTime)
		argIdx++
	}
	if req.EndTime != "" {
		setClauses += fmt.Sprintf("end_time = $%d, ", argIdx)
		args = append(args, req.EndTime)
		argIdx++
	}

	if setClauses == "" {
		return nil
	}

	// Remove trailing ", "
	setClauses = setClauses[:len(setClauses)-2]

	query := fmt.Sprintf("UPDATE bookings SET %s WHERE id = $%d", setClauses, argIdx)
	args = append(args, id)

	_, err := r.db.Exec(query, args...)
	return err
}

// Cancel sets a booking's status to cancelled.
func (r *BookingRepository) Cancel(id string) error {
	_, err := r.db.Exec(`UPDATE bookings SET status = 'cancelled' WHERE id = $1`, id)
	return err
}

// IsSlotAvailable checks if a time slot is free for a given room and date.
func (r *BookingRepository) IsSlotAvailable(roomID, date, startTime string) (bool, error) {
	var count int
	err := r.db.QueryRow(`
		SELECT COUNT(*) FROM bookings
		WHERE room_id = $1 AND booking_date = $2 AND start_time = $3 AND status != 'cancelled'`,
		roomID, date, startTime,
	).Scan(&count)
	if err != nil {
		return false, err
	}
	return count == 0, nil
}
