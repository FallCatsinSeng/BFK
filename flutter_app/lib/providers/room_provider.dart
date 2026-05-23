import 'package:flutter/material.dart';
import '../models/room.dart';
import '../models/mock_data.dart';
import '../services/room_service.dart';

/// Room state management via Provider.
/// Falls back to mock data when the backend is unreachable.
class RoomProvider extends ChangeNotifier {
  final RoomService _roomService = RoomService();

  List<Room> _rooms = [];
  List<String> _categories = MockData.roomCategories;
  bool _isLoading = false;
  String? _error;

  List<Room> get rooms => _rooms;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load rooms from API with optional type filter.
  Future<void> loadRooms({String? type, String? date}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _rooms = await _roomService.getRooms(type: type, date: date);
      _error = null;
    } catch (_) {
      // Fallback to mock data
      _rooms = MockData.rooms;
      if (type != null && type != 'All' && type != 'all') {
        _rooms = _rooms.where((r) {
          switch (type.toLowerCase()) {
            case 'room':
              return r.type == RoomType.room;
            case 'lab':
              return r.type == RoomType.lab;
            case 'auditorium':
              return r.type == RoomType.auditorium;
            default:
              return true;
          }
        }).toList();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load categories from API.
  Future<void> loadCategories() async {
    try {
      _categories = await _roomService.getCategories();
      // Capitalize first letter
      _categories = _categories.map((c) =>
          c[0].toUpperCase() + c.substring(1)).toList();
    } catch (_) {
      _categories = MockData.roomCategories;
    }
    notifyListeners();
  }

  /// Get filtered rooms by category index.
  List<Room> getFilteredRooms(int categoryIndex) {
    if (categoryIndex == 0) return _rooms;
    final category = _categories[categoryIndex];
    return _rooms.where((room) {
      switch (category.toLowerCase()) {
        case 'room':
          return room.type == RoomType.room;
        case 'lab':
          return room.type == RoomType.lab;
        case 'auditorium':
          return room.type == RoomType.auditorium;
        default:
          return true;
      }
    }).toList();
  }
}
