import 'package:flutter/foundation.dart' show kIsWeb;

/// API configuration constants.
/// Automatically detects the correct base URL based on platform.
class ApiConfig {
  ApiConfig._();

  /// Base URL for the Go backend.
  /// - Flutter Web: http://localhost:8080
  /// - Android Emulator: http://10.0.2.2:8080
  /// - Others: http://localhost:8080
  ///
  /// Override this if your backend runs on a different host/port.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    // For mobile, default to Android emulator address.
    // Change to your machine's IP for physical devices.
    return 'http://10.0.2.2:8080';
  }

  /// API version prefix.
  static const String apiV1 = '/api/v1';

  /// Full base path.
  static String get apiBase => '$baseUrl$apiV1';

  // Auth endpoints
  static String get login => '$apiBase/auth/login';
  static String get register => '$apiBase/auth/register';
  static String get googleLogin => '$apiBase/auth/google';
  static String get otpSend => '$apiBase/auth/otp/send';
  static String get otpVerify => '$apiBase/auth/otp/verify';
  static String get refreshToken => '$apiBase/auth/refresh';
  static String get faceVerify => '$apiBase/auth/face-verify';

  // User endpoints
  static String get currentUser => '$apiBase/users/me';

  // Room endpoints
  static String get rooms => '$apiBase/rooms';
  static String get roomCategories => '$apiBase/rooms/categories';
  static String roomById(String id) => '$apiBase/rooms/$id';

  // Booking endpoints
  static String get bookings => '$apiBase/bookings';
  static String bookingById(String id) => '$apiBase/bookings/$id';

  // Calendar endpoint
  static String calendar(int year, int month) => '$apiBase/calendar/$year/$month';

  // Health check
  static String get health => '$baseUrl/health';
}
