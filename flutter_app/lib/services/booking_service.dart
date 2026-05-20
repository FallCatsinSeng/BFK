import '../models/booking.dart';
import '../models/room.dart';
import 'api_client.dart';
import 'api_config.dart';

/// Service for booking-related API calls.
class BookingService {
  final ApiClient _client = ApiClient();

  /// Fetch user's bookings with optional status filter.
  Future<List<Booking>> getBookings({String? status, String? date}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;
    if (date != null) queryParams['date'] = date;

    final response = await _client.dio.get(
      ApiConfig.bookings,
      queryParameters: queryParams,
    );

    final List<dynamic> bookingsJson = response.data['bookings'] ?? [];
    return bookingsJson.map((json) => _parseBooking(json)).toList();
  }

  /// Create a new booking.
  Future<Booking> createBooking({
    required String roomId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final response = await _client.dio.post(
      ApiConfig.bookings,
      data: {
        'room_id': roomId,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
      },
    );

    return _parseBooking(response.data['booking']);
  }

  /// Get a single booking by ID.
  Future<Booking> getBooking(String id) async {
    final response = await _client.dio.get(ApiConfig.bookingById(id));
    return _parseBooking(response.data);
  }

  /// Update a booking (fix booking).
  Future<void> updateBooking(String id, {String? date, String? startTime, String? endTime}) async {
    final data = <String, dynamic>{};
    if (date != null) data['date'] = date;
    if (startTime != null) data['start_time'] = startTime;
    if (endTime != null) data['end_time'] = endTime;

    await _client.dio.put(ApiConfig.bookingById(id), data: data);
  }

  /// Cancel a booking.
  Future<void> cancelBooking(String id) async {
    await _client.dio.delete(ApiConfig.bookingById(id));
  }

  Booking _parseBooking(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      room: Room(
        id: json['room_id'] ?? '',
        name: json['room_name'] ?? '',
        type: _parseRoomType(json['room_type']),
        status: RoomStatus.booked,
        timeSlot: '${json['start_time'] ?? ''} - ${json['end_time'] ?? ''}',
        description: '',
        location: json['room_location'] ?? '',
        date: DateTime.tryParse(json['booking_date'] ?? '') ?? DateTime.now(),
        imageUrl: json['room_image_url'],
      ),
      bookingDate: DateTime.tryParse(json['booking_date'] ?? '') ?? DateTime.now(),
      timeSlot: '${json['start_time'] ?? ''} - ${json['end_time'] ?? ''}',
      status: _parseBookingStatus(json['status']),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  RoomType _parseRoomType(String? type) {
    switch (type) {
      case 'lab':
        return RoomType.lab;
      case 'auditorium':
        return RoomType.auditorium;
      default:
        return RoomType.room;
    }
  }

  BookingStatus _parseBookingStatus(String? status) {
    switch (status) {
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.upcoming;
    }
  }
}
