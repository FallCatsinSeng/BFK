package repository

import (
	"database/sql"

	"github.com/FallCatsinSeng/BFK/backend/internal/models"
)

// UserRepository handles user database operations.
type UserRepository struct {
	db *sql.DB
}

// NewUserRepository creates a new UserRepository.
func NewUserRepository(db *sql.DB) *UserRepository {
	return &UserRepository{db: db}
}

// Create inserts a new user into the database.
func (r *UserRepository) Create(user *models.User) error {
	return r.db.QueryRow(`
		INSERT INTO users (username, email, password_hash, google_id)
		VALUES ($1, $2, $3, $4)
		RETURNING id, created_at`,
		user.Username, user.Email, user.PasswordHash, user.GoogleID,
	).Scan(&user.ID, &user.CreatedAt)
}

// FindByID retrieves a user by ID.
func (r *UserRepository) FindByID(id string) (*models.User, error) {
	user := &models.User{}
	err := r.db.QueryRow(`
		SELECT id, username, email, password_hash, avatar_url, google_id, created_at
		FROM users WHERE id = $1`, id,
	).Scan(&user.ID, &user.Username, &user.Email, &user.PasswordHash,
		&user.AvatarURL, &user.GoogleID, &user.CreatedAt)
	if err != nil {
		return nil, err
	}
	return user, nil
}

// FindByUsername retrieves a user by username.
func (r *UserRepository) FindByUsername(username string) (*models.User, error) {
	user := &models.User{}
	err := r.db.QueryRow(`
		SELECT id, username, email, password_hash, avatar_url, google_id, created_at
		FROM users WHERE username = $1`, username,
	).Scan(&user.ID, &user.Username, &user.Email, &user.PasswordHash,
		&user.AvatarURL, &user.GoogleID, &user.CreatedAt)
	if err != nil {
		return nil, err
	}
	return user, nil
}

// FindByEmail retrieves a user by email.
func (r *UserRepository) FindByEmail(email string) (*models.User, error) {
	user := &models.User{}
	err := r.db.QueryRow(`
		SELECT id, username, email, password_hash, avatar_url, google_id, created_at
		FROM users WHERE email = $1`, email,
	).Scan(&user.ID, &user.Username, &user.Email, &user.PasswordHash,
		&user.AvatarURL, &user.GoogleID, &user.CreatedAt)
	if err != nil {
		return nil, err
	}
	return user, nil
}

// FindByGoogleID retrieves a user by Google ID.
func (r *UserRepository) FindByGoogleID(googleID string) (*models.User, error) {
	user := &models.User{}
	err := r.db.QueryRow(`
		SELECT id, username, email, password_hash, avatar_url, google_id, created_at
		FROM users WHERE google_id = $1`, googleID,
	).Scan(&user.ID, &user.Username, &user.Email, &user.PasswordHash,
		&user.AvatarURL, &user.GoogleID, &user.CreatedAt)
	if err != nil {
		return nil, err
	}
	return user, nil
}
