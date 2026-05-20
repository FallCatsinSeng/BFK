import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_client.dart';
import 'api_config.dart';

/// Service for authentication operations.
class AuthService {
  final ApiClient _client = ApiClient();

  /// Login with username and password.
  /// Returns the user on success.
  Future<AppUser> login(String username, String password) async {
    final response = await _client.dio.post(
      ApiConfig.login,
      data: {'username': username, 'password': password},
    );

    await _client.saveTokens(
      accessToken: response.data['access_token'],
      refreshToken: response.data['refresh_token'],
    );

    return _parseUser(response.data['user']);
  }

  /// Register a new user.
  Future<AppUser> register(String username, String email, String password) async {
    final response = await _client.dio.post(
      ApiConfig.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    await _client.saveTokens(
      accessToken: response.data['access_token'],
      refreshToken: response.data['refresh_token'],
    );

    return _parseUser(response.data['user']);
  }

  /// Google OAuth login.
  Future<AppUser> googleLogin(String token) async {
    final response = await _client.dio.post(
      ApiConfig.googleLogin,
      data: {'token': token},
    );

    await _client.saveTokens(
      accessToken: response.data['access_token'],
      refreshToken: response.data['refresh_token'],
    );

    return _parseUser(response.data['user']);
  }

  /// Send OTP to email.
  Future<void> sendOtp(String email) async {
    await _client.dio.post(
      ApiConfig.otpSend,
      data: {'email': email},
    );
  }

  /// Verify OTP code.
  Future<bool> verifyOtp(String email, String code) async {
    try {
      final response = await _client.dio.post(
        ApiConfig.otpVerify,
        data: {'email': email, 'code': code},
      );
      return response.data['verified'] == true;
    } on DioException {
      return false;
    }
  }

  /// Face verification (placeholder).
  Future<bool> faceVerify() async {
    try {
      final response = await _client.dio.post(ApiConfig.faceVerify);
      return response.data['verified'] == true;
    } on DioException {
      return false;
    }
  }

  /// Get current authenticated user.
  Future<AppUser> getCurrentUser() async {
    final response = await _client.dio.get(ApiConfig.currentUser);
    return _parseUser(response.data);
  }

  /// Logout (clear tokens).
  Future<void> logout() async {
    await _client.clearTokens();
  }

  /// Check if user is authenticated.
  Future<bool> isAuthenticated() => _client.isAuthenticated();

  AppUser _parseUser(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }
}
