import '../models/room.dart';
import 'api_client.dart';
import 'api_config.dart';

/// Service for room-related API calls.
class RoomService {
  final ApiClient _client = ApiClient();

  /// Fetch all rooms with optional type/date filter.
  Future<List<Room>> getRooms({String? type, String? date}) async {
    final queryParams = <String, dynamic>{};
    if (type != null && type != 'all') queryParams['type'] = type;
    if (date != null) queryParams['date'] = date;

    final response = await _client.dio.get(
      ApiConfig.rooms,
      queryParameters: queryParams,
    );

    final List<dynamic> roomsJson = response.data['rooms'] ?? [];
    return roomsJson.map((json) => _parseRoom(json)).toList();
  }

  /// Fetch a single room by ID with time slots.
  Future<RoomDetail> getRoomDetail(String id) async {
    final response = await _client.dio.get(ApiConfig.roomById(id));
    final roomJson = response.data['room'];
    final slotsJson = response.data['time_slots'] as List<dynamic>? ?? [];

    return RoomDetail(
      room: _parseRoom(roomJson),
      timeSlots: slotsJson.map((s) => TimeSlotModel(
        id: s['id'],
        startTime: s['start_time'],
        endTime: s['end_time'],
      )).toList(),
    );
  }

  /// Fetch available categories.
  Future<List<String>> getCategories() async {
    final response = await _client.dio.get(ApiConfig.roomCategories);
    final List<dynamic> cats = response.data['categories'] ?? [];
    return cats.map((c) => c.toString()).toList();
  }

  /// Fetch calendar availability for a month.
  Future<List<CalendarDayAvailability>> getCalendarAvailability(int year, int month) async {
    final response = await _client.dio.get(ApiConfig.calendar(year, month));
    final List<dynamic> days = response.data['days'] ?? [];
    return days.map((d) => CalendarDayAvailability(
      date: d['date'],
      day: d['day'],
      isAvailable: d['is_available'] ?? true,
      bookingsCount: d['bookings_count'] ?? 0,
      totalSlots: d['total_slots'] ?? 0,
    )).toList();
  }

  Room _parseRoom(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: _parseRoomType(json['type']),
      status: _parseRoomStatus(json['status']),
      timeSlot: json['time_slot'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      date: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      imageUrl: json['image_url'],
    );
  }

  RoomType _parseRoomType(String? type) {
    switch (type) {
      case 'lab':
        return RoomType.lab;
      case 'auditorium':
        return RoomType.auditorium;
      case 'room':
      default:
        return RoomType.room;
    }
  }

  RoomStatus _parseRoomStatus(String? status) {
    switch (status) {
      case 'booked':
        return RoomStatus.booked;
      case 'available':
      default:
        return RoomStatus.available;
    }
  }
}

/// Extended room info with time slots.
class RoomDetail {
  final Room room;
  final List<TimeSlotModel> timeSlots;

  const RoomDetail({required this.room, required this.timeSlots});
}

/// Time slot model from API.
class TimeSlotModel {
  final String id;
  final String startTime;
  final String endTime;

  const TimeSlotModel({
    required this.id,
    required this.startTime,
    required this.endTime,
  });
}

/// Calendar day availability from API.
class CalendarDayAvailability {
  final String date;
  final int day;
  final bool isAvailable;
  final int bookingsCount;
  final int totalSlots;

  const CalendarDayAvailability({
    required this.date,
    required this.day,
    required this.isAvailable,
    required this.bookingsCount,
    required this.totalSlots,
  });
}
