import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/mock_data.dart';
import '../services/booking_service.dart';

/// Booking state management via Provider.
/// Falls back to mock data when the backend is unreachable.
class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _error;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Booking> get upcomingBookings =>
      _bookings.where((b) => b.status == BookingStatus.upcoming).toList();

  List<Booking> get completedBookings =>
      _bookings.where((b) => b.status == BookingStatus.completed).toList();

  /// Load bookings from API.
  Future<void> loadBookings({String? status}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await _bookingService.getBookings(status: status);
      _error = null;
    } catch (_) {
      // Fallback to mock data
      _bookings = MockData.bookings;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create a new booking.
  Future<bool> createBooking({
    required String roomId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final booking = await _bookingService.createBooking(
        roomId: roomId,
        date: date,
        startTime: startTime,
        endTime: endTime,
      );
      _bookings.insert(0, booking);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create booking';
      notifyListeners();
      return false;
    }
  }

  /// Cancel a booking.
  Future<bool> cancelBooking(String id) async {
    try {
      await _bookingService.cancelBooking(id);
      _bookings.removeWhere((b) => b.id == id);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Update a booking (fix booking).
  Future<bool> updateBooking(String id, {String? date, String? startTime, String? endTime}) async {
    try {
      await _bookingService.updateBooking(id, date: date, startTime: startTime, endTime: endTime);
      await loadBookings(); // Reload
      return true;
    } catch (_) {
      return false;
    }
  }
}
