package handlers

import (
	"net/http"
	"strconv"

	"github.com/FallCatsinSeng/BFK/backend/internal/models"
	"github.com/FallCatsinSeng/BFK/backend/internal/repository"
	"github.com/gin-gonic/gin"
)

// RoomHandler handles room-related endpoints.
type RoomHandler struct {
	roomRepo *repository.RoomRepository
}

// NewRoomHandler creates a new RoomHandler.
func NewRoomHandler(roomRepo *repository.RoomRepository) *RoomHandler {
	return &RoomHandler{roomRepo: roomRepo}
}

// ListRooms returns all rooms with optional type/date filter.
// GET /api/v1/rooms?type=lab&date=2026-04-27
func (h *RoomHandler) ListRooms(c *gin.Context) {
	var filter models.RoomFilter
	if err := c.ShouldBindQuery(&filter); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid query parameters"})
		return
	}

	rooms, err := h.roomRepo.FindAll(filter)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch rooms"})
		return
	}

	if rooms == nil {
		rooms = []models.RoomWithStatus{}
	}

	c.JSON(http.StatusOK, gin.H{
		"rooms": rooms,
		"total": len(rooms),
	})
}

// GetRoom returns a single room by ID with its time slots.
// GET /api/v1/rooms/:id
func (h *RoomHandler) GetRoom(c *gin.Context) {
	id := c.Param("id")

	room, err := h.roomRepo.FindByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room not found"})
		return
	}

	slots, err := h.roomRepo.GetTimeSlots(id)
	if err != nil {
		slots = []models.TimeSlot{}
	}

	c.JSON(http.StatusOK, gin.H{
		"room":       room,
		"time_slots": slots,
	})
}

// GetCategories returns all distinct room types.
// GET /api/v1/rooms/categories
func (h *RoomHandler) GetCategories(c *gin.Context) {
	categories, err := h.roomRepo.GetCategories()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch categories"})
		return
	}

	// Add "All" as the first option
	allCategories := append([]string{"all"}, categories...)

	c.JSON(http.StatusOK, gin.H{
		"categories": allCategories,
	})
}

// GetCalendarAvailability returns room availability for a given month.
// GET /api/v1/calendar/:year/:month
func (h *RoomHandler) GetCalendarAvailability(c *gin.Context) {
	yearStr := c.Param("year")
	monthStr := c.Param("month")

	year, err := strconv.Atoi(yearStr)
	if err != nil || year < 2020 || year > 2030 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid year"})
		return
	}

	month, err := strconv.Atoi(monthStr)
	if err != nil || month < 1 || month > 12 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid month"})
		return
	}

	calendar, err := h.roomRepo.GetCalendarAvailability(year, month)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get calendar data"})
		return
	}

	c.JSON(http.StatusOK, calendar)
}
