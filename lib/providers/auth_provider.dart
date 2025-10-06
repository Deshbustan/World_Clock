import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_clock/models/user.dart';
import 'package:world_clock/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = true; // Start in a loading state to check for a saved user
  bool _isGuest = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest;

  static const String _savedUserKey = 'saved_username';

  AuthProvider() {
    // When the app starts, automatically check if a user was saved
    _checkSavedUser();
  }

  // Checks local storage for a remembered user
  Future<void> _checkSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString(_savedUserKey);

    if (savedUsername != null) {
      // If a user was saved, log them in automatically
      _user = User(username: savedUsername);
      _isGuest = false;
    }
    // We are done checking, so stop the initial loading state
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> signUp(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    final String? error = await _authService.signUp(username, password);
    _isLoading = false;
    notifyListeners();
    return error;
  }

  // The login method now accepts a 'rememberMe' flag
  Future<bool> login(String username, String password, {required bool rememberMe}) async {
    _isLoading = true;
    notifyListeners();
    
    _user = await _authService.login(username, password);
    
    final prefs = await SharedPreferences.getInstance();
    if (_user != null && rememberMe) {
      // If login is successful and "Remember Me" is checked, save the username
      await prefs.setString(_savedUserKey, _user!.username);
    } else {
      // Otherwise, ensure no user is saved
      await prefs.remove(_savedUserKey);
    }

    _isLoading = false;
    notifyListeners();
    return _user != null;
  }

  // New method to handle guest login
  void loginAsGuest() {
    _user = User(username: 'Guest'); // Create a temporary guest user
    _isGuest = true;
    notifyListeners();
  }

  // The logout method now also clears the saved user session
  Future<void> logout() async {
    await _authService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedUserKey); // Clear the saved username
    _user = null;
    _isGuest = false;
    notifyListeners();
  }
}