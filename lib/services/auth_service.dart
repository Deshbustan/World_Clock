import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_clock/models/user.dart';

class AuthService {
  static const _usersKey = 'users';

  // Method to handle user registration
  Future<String?> signUp(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing users or create an empty list
    final String usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> users = jsonDecode(usersJson);

    // Check if username already exists
    if (users.any((user) => user['username'] == username)) {
      return 'Username already exists.';
    }

    // Add new user
    users.add({'username': username, 'password': password});
    await prefs.setString(_usersKey, jsonEncode(users));
    
    return null; // Return null on success
  }

  // Method to handle user login
  Future<User?> login(String username, String password) async {
    // This now checks the list of registered users
    final prefs = await SharedPreferences.getInstance();
    final String usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> users = jsonDecode(usersJson);

    // Find the user
    final user = users.firstWhere(
      (user) => user['username'] == username && user['password'] == password,
      orElse: () => null, // Return null if not found
    );
    
    if (user != null) {
      return User(username: user['username']);
    }

    // For demonstration, keep the original fallback
    if (username.isNotEmpty && password == 'password') {
      return User(username: username);
    }
    
    return null;
  }

  Future<void> logout() async {
    // No changes needed here
  }
}