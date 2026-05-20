import 'room.dart';
import 'booking.dart';
import 'user.dart';

/// Mock data for the application UI.
/// Ready to be replaced with API calls later.
class MockData {
  MockData._();

  static const AppUser currentUser = AppUser(
    id: 'user_001',
    username: 'user',
    email: 'youremail@gmail.com',
  );

  static final List<Room> rooms = [
    Room(
      id: 'room_001',
      name: 'Computer Lab',
      type: RoomType.lab,
      status: RoomStatus.available,
      timeSlot: '9:00 AM - 11:00 AM',
      description:
          'This room is air-conditioned and equipped with high-performance computers. It also consumes a significant amount of electricity.',
      location: 'Engineering Building, 2nd Floor\nRoom 2',
      date: DateTime(2026, 4, 27),
    ),
    Room(
      id: 'room_002',
      name: 'Computer Lab',
      type: RoomType.lab,
      status: RoomStatus.available,
      timeSlot: '9:00 AM - 11:00 AM',
      description:
          'This room is air-conditioned and equipped with high-performance computers. It also consumes a significant amount of electricity.',
      location: 'Engineering Building, 2nd Floor\nRoom 3',
      date: DateTime(2026, 4, 27),
    ),
    Room(
      id: 'room_003',
      name: 'Computer Lab',
      type: RoomType.lab,
      status: RoomStatus.available,
      timeSlot: '9:00 AM - 11:00 AM',
      description:
          'This room is air-conditioned and equipped with high-performance computers. It also consumes a significant amount of electricity.',
      location: 'Engineering Building, 2nd Floor\nRoom 4',
      date: DateTime(2026, 4, 27),
    ),
    Room(
      id: 'room_004',
      name: 'Computer Lab',
      type: RoomType.lab,
      status: RoomStatus.booked,
      timeSlot: '9:00 AM - 11:00 AM',
      description:
          'This room is air-conditioned and equipped with high-performance computers. It also consumes a significant amount of electricity.',
      location: 'Engineering Building, 2nd Floor\nRoom 5',
      date: DateTime(2026, 4, 27),
    ),
    Room(
      id: 'room_005',
      name: 'Auditorium',
      type: RoomType.auditorium,
      status: RoomStatus.booked,
      timeSlot: '9:00 AM - 10:00 AM',
      description:
          'This room is air-conditioned and equipped with high-performance computers. It also consumes a significant amount of electricity.',
      location: 'Main Building, 1st Floor\nAuditorium A',
      date: DateTime(2026, 4, 27),
    ),
    Room(
      id: 'room_006',
      name: 'Auditorium',
      type: RoomType.auditorium,
      status: RoomStatus.available,
      timeSlot: '11:00 AM - 1:00 PM',
      description:
          'Large auditorium with stage, projector, and seating for 200 people.',
      location: 'Main Building, 1st Floor\nAuditorium B',
      date: DateTime(2026, 4, 27),
    ),
  ];

  static final List<Booking> bookings = [
    Booking(
      id: 'booking_001',
      room: rooms[4],
      bookingDate: DateTime(2026, 4, 27),
      timeSlot: '9:00 AM - 10:00 AM',
      status: BookingStatus.upcoming,
      createdAt: DateTime(2026, 4, 25),
    ),
    Booking(
      id: 'booking_002',
      room: rooms[4],
      bookingDate: DateTime(2026, 4, 28),
      timeSlot: '9:00 AM - 10:00 AM',
      status: BookingStatus.upcoming,
      createdAt: DateTime(2026, 4, 25),
    ),
    Booking(
      id: 'booking_003',
      room: rooms[4],
      bookingDate: DateTime(2026, 4, 29),
      timeSlot: '9:00 AM - 10:00 AM',
      status: BookingStatus.upcoming,
      createdAt: DateTime(2026, 4, 24),
    ),
    Booking(
      id: 'booking_004',
      room: rooms[4],
      bookingDate: DateTime(2026, 4, 20),
      timeSlot: '9:00 AM - 10:00 AM',
      status: BookingStatus.completed,
      createdAt: DateTime(2026, 4, 18),
    ),
    Booking(
      id: 'booking_005',
      room: rooms[4],
      bookingDate: DateTime(2026, 4, 15),
      timeSlot: '11:00 AM - 1:00 PM',
      status: BookingStatus.completed,
      createdAt: DateTime(2026, 4, 13),
    ),
  ];

  /// Categories for filtering rooms
  static const List<String> roomCategories = [
    'All',
    'Room',
    'Lab',
    'Auditorium',
  ];

  /// Generate a week of dates starting from a given date
  static List<DateTime> getWeekDates(DateTime startDate) {
    return List.generate(7, (index) => startDate.add(Duration(days: index)));
  }
}
