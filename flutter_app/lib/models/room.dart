/// Represents a bookable room/space in the application.
enum RoomType { room, lab, auditorium }

enum RoomStatus { available, booked }

class Room {
  final String id;
  final String name;
  final RoomType type;
  final RoomStatus status;
  final String timeSlot;
  final String description;
  final String location;
  final String? imageUrl;
  final DateTime date;

  const Room({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.timeSlot,
    required this.description,
    required this.location,
    required this.date,
    this.imageUrl,
  });

  bool get isAvailable => status == RoomStatus.available;

  String get typeLabel {
    switch (type) {
      case RoomType.room:
        return 'Room';
      case RoomType.lab:
        return 'Lab';
      case RoomType.auditorium:
        return 'Auditorium';
    }
  }

  Room copyWith({
    String? id,
    String? name,
    RoomType? type,
    RoomStatus? status,
    String? timeSlot,
    String? description,
    String? location,
    String? imageUrl,
    DateTime? date,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      timeSlot: timeSlot ?? this.timeSlot,
      description: description ?? this.description,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
    );
  }
}
