import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/mock_data.dart';
import '../services/auth_service.dart';

/// Authentication state management via Provider.
/// Falls back to mock data when the backend is unreachable.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String get userEmail => _user?.email ?? MockData.currentUser.email;

  /// Initialize: check if already logged in.
  Future<void> init() async {
    try {
      _isAuthenticated = await _authService.isAuthenticated();
      if (_isAuthenticated) {
        _user = await _authService.getCurrentUser();
      }
    } catch (_) {
      // Backend unavailable, use mock
      _user = MockData.currentUser;
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  /// Login with username/password.
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.login(username, password);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Fallback: accept demo credentials offline
      if (username == 'user' && password == 'password123') {
        _user = MockData.currentUser;
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'Invalid credentials';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register a new user.
  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.register(username, email, password);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Send OTP.
  Future<bool> sendOtp() async {
    try {
      await _authService.sendOtp(userEmail);
      return true;
    } catch (_) {
      return true; // Allow offline flow
    }
  }

  /// Verify OTP.
  Future<bool> verifyOtp(String code) async {
    try {
      return await _authService.verifyOtp(userEmail, code);
    } catch (_) {
      return code.length == 6; // Accept offline
    }
  }

  /// Face verify.
  Future<bool> faceVerify() async {
    try {
      return await _authService.faceVerify();
    } catch (_) {
      return true; // Accept offline
    }
  }

  /// Logout.
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
