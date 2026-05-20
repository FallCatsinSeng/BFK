import 'room.dart';

/// Represents a confirmed booking.
enum BookingStatus { upcoming, completed, cancelled }

class Booking {
  final String id;
  final Room room;
  final DateTime bookingDate;
  final String timeSlot;
  final BookingStatus status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.room,
    required this.bookingDate,
    required this.timeSlot,
    required this.status,
    required this.createdAt,
  });

  bool get isUpcoming => status == BookingStatus.upcoming;

  Booking copyWith({
    String? id,
    Room? room,
    DateTime? bookingDate,
    String? timeSlot,
    BookingStatus? status,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      room: room ?? this.room,
      bookingDate: bookingDate ?? this.bookingDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
