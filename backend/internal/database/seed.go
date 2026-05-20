package database

import (
	"database/sql"
	"log"

	"golang.org/x/crypto/bcrypt"
)

// SeedData inserts initial rooms and a demo user.
func SeedData(db *sql.DB) error {
	// Check if data already exists
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM rooms").Scan(&count)
	if err != nil {
		return err
	}
	if count > 0 {
		log.Println("Seed data already exists, skipping")
		return nil
	}

	// Create demo user
	hash, _ := bcrypt.GenerateFromPassword([]byte("password123"), bcrypt.DefaultCost)
	_, err = db.Exec(`
		INSERT INTO users (username, email, password_hash) 
		VALUES ($1, $2, $3) ON CONFLICT DO NOTHING`,
		"user", "youremail@gmail.com", string(hash))
	if err != nil {
		return err
	}

	// Insert rooms
	rooms := []struct {
		Name        string
		Type        string
		Description string
		Location    string
		Capacity    int
		HasAC       bool
	}{
		{
			Name:        "Computer Lab",
			Type:        "lab",
			Description: "This room is air-conditioned and equipped with high-performance computers. It also consumes a significant amount of electricity.",
			Location:    "Engineering Building, 2nd Floor\nRoom 2",
			Capacity:    30,
			HasAC:       true,
		},
		{
			Name:        "Computer Lab",
			Type:        "lab",
			Description: "This room is air-conditioned and equipped with high-performance computers. It also consumes a significant amount of electricity.",
			Location:    "Engineering Building, 2nd Floor\nRoom 3",
			Capacity:    30,
			HasAC:       true,
		},
		{
			Name:        "Computer Lab",
			Type:        "lab",
			Description: "This room is air-conditioned and equipped with high-performance computers. It also consumes a significant amount of electricity.",
			Location:    "Engineering Building, 2nd Floor\nRoom 4",
			Capacity:    30,
			HasAC:       true,
		},
		{
			Name:        "Auditorium",
			Type:        "auditorium",
			Description: "Large auditorium with stage, projector, and seating for 200 people.",
			Location:    "Main Building, 1st Floor\nAuditorium A",
			Capacity:    200,
			HasAC:       true,
		},
		{
			Name:        "Auditorium",
			Type:        "auditorium",
			Description: "Medium-sized auditorium with full AV setup.",
			Location:    "Main Building, 1st Floor\nAuditorium B",
			Capacity:    150,
			HasAC:       true,
		},
		{
			Name:        "Meeting Room",
			Type:        "room",
			Description: "Small meeting room for team discussions and presentations.",
			Location:    "Engineering Building, 3rd Floor\nRoom 301",
			Capacity:    12,
			HasAC:       true,
		},
	}

	for _, r := range rooms {
		_, err = db.Exec(`
			INSERT INTO rooms (name, type, description, location, capacity, has_ac) 
			VALUES ($1, $2, $3, $4, $5, $6)`,
			r.Name, r.Type, r.Description, r.Location, r.Capacity, r.HasAC)
		if err != nil {
			return err
		}
	}

	// Insert time slots for each room
	_, err = db.Exec(`
		INSERT INTO time_slots (room_id, start_time, end_time)
		SELECT r.id, s.start_time::TIME, s.end_time::TIME
		FROM rooms r
		CROSS JOIN (VALUES 
			('09:00', '11:00'),
			('11:00', '13:00'),
			('14:00', '16:00'),
			('16:00', '18:00')
		) AS s(start_time, end_time)
	`)
	if err != nil {
		return err
	}

	log.Println("Seed data inserted successfully")
	return nil
}
