package services

import (
	"crypto/rand"
	"database/sql"
	"fmt"
	"log"
	"math/big"
	"time"

	"github.com/FallCatsinSeng/BFK/backend/internal/config"
)

// OTPService handles OTP generation, storage, and verification.
type OTPService struct {
	cfg *config.Config
	db  *sql.DB
}

// NewOTPService creates a new OTPService.
func NewOTPService(cfg *config.Config) *OTPService {
	return &OTPService{cfg: cfg}
}

// SetDB sets the database connection (called after initialization).
func (s *OTPService) SetDB(db *sql.DB) {
	s.db = db
}

// GenerateOTP creates a random 6-digit code.
func (s *OTPService) GenerateOTP() string {
	max := big.NewInt(999999)
	n, err := rand.Int(rand.Reader, max)
	if err != nil {
		// Fallback to simple random
		return "123456"
	}
	return fmt.Sprintf("%06d", n.Int64())
}

// SendOTP generates and stores an OTP, then sends it via email.
func (s *OTPService) SendOTP(email string) error {
	code := s.GenerateOTP()
	expiry := time.Now().Add(time.Duration(s.cfg.OTPExpiry) * time.Minute)

	// Store in database if available
	if s.db != nil {
		// Invalidate previous OTPs for this email
		_, _ = s.db.Exec(`UPDATE otp_codes SET used = true WHERE email = $1 AND used = false`, email)

		// Insert new OTP
		_, err := s.db.Exec(`
			INSERT INTO otp_codes (email, code, expires_at)
			VALUES ($1, $2, $3)`, email, code, expiry)
		if err != nil {
			return err
		}
	}

	// Send email (log for development)
	log.Printf("[OTP] Code for %s: %s (expires at %s)", email, code, expiry.Format(time.RFC3339))

	// In production, uncomment and configure:
	// return s.sendEmail(email, code)
	return nil
}

// VerifyOTP validates the OTP code for a given email.
// NOTE: Verification is currently DISABLED — any 6-digit code is accepted.
// To re-enable, remove the early return below.
func (s *OTPService) VerifyOTP(email, code string) (bool, error) {
	// === VERIFICATION DISABLED ===
	// Accept any 6-digit code without checking the database.
	log.Printf("[OTP] Verification DISABLED — auto-accepting code %s for %s", code, email)
	return len(code) == 6, nil
	// === END DISABLED BLOCK ===

	// --- Original verification logic (re-enable when ready) ---
	// if s.db == nil {
	// 	return len(code) == 6, nil
	// }
	//
	// var id string
	// err := s.db.QueryRow(`
	// 	SELECT id FROM otp_codes
	// 	WHERE email = $1 AND code = $2 AND used = false AND expires_at > NOW()
	// 	ORDER BY created_at DESC LIMIT 1`, email, code).Scan(&id)
	// if err != nil {
	// 	if err == sql.ErrNoRows {
	// 		return false, nil
	// 	}
	// 	return false, err
	// }
	//
	// _, _ = s.db.Exec(`UPDATE otp_codes SET used = true WHERE id = $1`, id)
	// return true, nil
}
