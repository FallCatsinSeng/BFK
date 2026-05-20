package database

import (
	"database/sql"
	"log"
)

// RunMigrations creates all required database tables.
func RunMigrations(db *sql.DB) error {
	migrations := []string{
		`CREATE EXTENSION IF NOT EXISTS "pgcrypto"`,

		// Users table
		`CREATE TABLE IF NOT EXISTS users (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			username VARCHAR(100) UNIQUE NOT NULL,
			email VARCHAR(255) UNIQUE NOT NULL,
			password_hash VARCHAR(255) NOT NULL DEFAULT '',
			avatar_url TEXT,
			google_id VARCHAR(255),
			created_at TIMESTAMPTZ DEFAULT NOW()
		)`,

		// Rooms table
		`CREATE TABLE IF NOT EXISTS rooms (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			name VARCHAR(200) NOT NULL,
			type VARCHAR(50) NOT NULL CHECK (type IN ('room', 'lab', 'auditorium')),
			description TEXT NOT NULL DEFAULT '',
			location TEXT NOT NULL DEFAULT '',
			image_url TEXT,
			capacity INT DEFAULT 0,
			has_ac BOOLEAN DEFAULT false,
			created_at TIMESTAMPTZ DEFAULT NOW()
		)`,

		// Time slots table
		`CREATE TABLE IF NOT EXISTS time_slots (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			room_id UUID REFERENCES rooms(id) ON DELETE CASCADE,
			start_time TIME NOT NULL,
			end_time TIME NOT NULL,
			day_of_week INT
		)`,

		// Bookings table
		`CREATE TABLE IF NOT EXISTS bookings (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			user_id UUID REFERENCES users(id) ON DELETE CASCADE,
			room_id UUID REFERENCES rooms(id) ON DELETE CASCADE,
			booking_date DATE NOT NULL,
			start_time TIME NOT NULL,
			end_time TIME NOT NULL,
			status VARCHAR(20) DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'completed', 'cancelled')),
			verified BOOLEAN DEFAULT false,
			created_at TIMESTAMPTZ DEFAULT NOW(),
			UNIQUE(room_id, booking_date, start_time)
		)`,

		// OTP codes table
		`CREATE TABLE IF NOT EXISTS otp_codes (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			email VARCHAR(255) NOT NULL,
			code VARCHAR(6) NOT NULL,
			expires_at TIMESTAMPTZ NOT NULL,
			used BOOLEAN DEFAULT false,
			created_at TIMESTAMPTZ DEFAULT NOW()
		)`,

		// Indexes
		`CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id)`,
		`CREATE INDEX IF NOT EXISTS idx_bookings_room_id ON bookings(room_id)`,
		`CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(booking_date)`,
		`CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status)`,
		`CREATE INDEX IF NOT EXISTS idx_rooms_type ON rooms(type)`,
		`CREATE INDEX IF NOT EXISTS idx_otp_email ON otp_codes(email)`,
	}

	for _, migration := range migrations {
		if _, err := db.Exec(migration); err != nil {
			return err
		}
	}

	log.Println("Database migrations completed")
	return nil
}
