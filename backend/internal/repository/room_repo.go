package repository

import (
	"database/sql"
	"fmt"
	"time"

	"github.com/FallCatsinSeng/BFK/backend/internal/models"
)

// RoomRepository handles room database operations.
type RoomRepository struct {
	db *sql.DB
}

// NewRoomRepository creates a new RoomRepository.
func NewRoomRepository(db *sql.DB) *RoomRepository {
	return &RoomRepository{db: db}
}

// FindAll retrieves all rooms with optional type filter.
func (r *RoomRepository) FindAll(filter models.RoomFilter) ([]models.RoomWithStatus, error) {
	query := `
		SELECT r.id, r.name, r.type, r.description, r.location, r.image_url,
			   r.capacity, r.has_ac, r.created_at
		FROM rooms r
		WHERE 1=1`
	args := []interface{}{}
	argIdx := 1

	if filter.Type != "" {
		query += fmt.Sprintf(" AND r.type = $%d", argIdx)
		args = append(args, filter.Type)
		argIdx++
	}

	query += " ORDER BY r.created_at ASC"

	rows, err := r.db.Query(query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	date := filter.Date
	if date == "" {
		date = time.Now().Format("2006-01-02")
	}

	var rooms []models.RoomWithStatus
	for rows.Next() {
		var room models.Room
		err := rows.Scan(&room.ID, &room.Name, &room.Type, &room.Description,
			&room.Location, &room.ImageURL, &room.Capacity, &room.HasAC, &room.CreatedAt)
		if err != nil {
			return nil, err
		}

		// Check booking status for the given date
		status := "available"
		var bookedCount int
		r.db.QueryRow(`
			SELECT COUNT(*) FROM bookings 
			WHERE room_id = $1 AND booking_date = $2 AND status != 'cancelled'`,
			room.ID, date).Scan(&bookedCount)
		if bookedCount > 0 {
			status = "booked"
		}

		// Get first available time slot
		timeSlot := ""
		r.db.QueryRow(`
			SELECT start_time || ' - ' || end_time FROM time_slots
			WHERE room_id = $1
			ORDER BY start_time LIMIT 1`, room.ID).Scan(&timeSlot)

		rooms = append(rooms, models.RoomWithStatus{
			Room:     room,
			Status:   status,
			TimeSlot: timeSlot,
		})
	}

	return rooms, nil
}

// FindByID retrieves a room by its ID.
func (r *RoomRepository) FindByID(id string) (*models.Room, error) {
	room := &models.Room{}
	err := r.db.QueryRow(`
		SELECT id, name, type, description, location, image_url, capacity, has_ac, created_at
		FROM rooms WHERE id = $1`, id,
	).Scan(&room.ID, &room.Name, &room.Type, &room.Description,
		&room.Location, &room.ImageURL, &room.Capacity, &room.HasAC, &room.CreatedAt)
	if err != nil {
		return nil, err
	}
	return room, nil
}

// GetTimeSlots retrieves all time slots for a room.
func (r *RoomRepository) GetTimeSlots(roomID string) ([]models.TimeSlot, error) {
	rows, err := r.db.Query(`
		SELECT id, room_id, start_time, end_time, day_of_week
		FROM time_slots WHERE room_id = $1
		ORDER BY start_time`, roomID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var slots []models.TimeSlot
	for rows.Next() {
		var slot models.TimeSlot
		err := rows.Scan(&slot.ID, &slot.RoomID, &slot.StartTime, &slot.EndTime, &slot.DayOfWeek)
		if err != nil {
			return nil, err
		}
		slots = append(slots, slot)
	}
	return slots, nil
}

// GetCategories returns distinct room types.
func (r *RoomRepository) GetCategories() ([]string, error) {
	rows, err := r.db.Query(`SELECT DISTINCT type FROM rooms ORDER BY type`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var categories []string
	for rows.Next() {
		var cat string
		if err := rows.Scan(&cat); err != nil {
			return nil, err
		}
		categories = append(categories, cat)
	}
	return categories, nil
}

// GetCalendarAvailability returns availability for each day in a month.
func (r *RoomRepository) GetCalendarAvailability(year, month int) (*models.CalendarResponse, error) {
	// Get first and last day of month
	firstDay := time.Date(year, time.Month(month), 1, 0, 0, 0, 0, time.UTC)
	lastDay := firstDay.AddDate(0, 1, -1)

	var totalSlots int
	r.db.QueryRow("SELECT COUNT(*) FROM time_slots").Scan(&totalSlots)

	days := []models.CalendarDay{}
	for d := firstDay; !d.After(lastDay); d = d.AddDate(0, 0, 1) {
		dateStr := d.Format("2006-01-02")
		var bookingsCount int
		r.db.QueryRow(`
			SELECT COUNT(*) FROM bookings 
			WHERE booking_date = $1 AND status != 'cancelled'`,
			dateStr).Scan(&bookingsCount)

		days = append(days, models.CalendarDay{
			Date:          dateStr,
			Day:           d.Day(),
			IsAvailable:   bookingsCount < totalSlots,
			BookingsCount: bookingsCount,
			TotalSlots:    totalSlots,
		})
	}

	return &models.CalendarResponse{
		Year:  year,
		Month: month,
		Days:  days,
	}, nil
}
