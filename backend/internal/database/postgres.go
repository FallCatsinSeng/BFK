package database

import (
	"database/sql"
	"log"

	"github.com/FallCatsinSeng/BFK/backend/internal/config"
	_ "github.com/lib/pq"
)

// Connect establishes connection to PostgreSQL.
func Connect(cfg *config.Config) (*sql.DB, error) {
	db, err := sql.Open("postgres", cfg.DatabaseURL)
	if err != nil {
		return nil, err
	}

	// Test connection
	if err := db.Ping(); err != nil {
		return nil, err
	}

	// Connection pool settings
	db.SetMaxOpenConns(25)
	db.SetMaxIdleConns(5)

	log.Println("Connected to PostgreSQL")
	return db, nil
}
