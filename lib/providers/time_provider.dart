import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_clock/models/world_time.dart';
import 'package:world_clock/services/api_service.dart';

class TimeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  WorldTime? _currentTime;
  bool _isLoading = true;
  String? _errorMessage;

  // Getters for the UI to access the state
  WorldTime? get currentTime => _currentTime;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Constructor: Called when the provider is first created
  TimeProvider() {
    loadInitialTime();
  }

  // Fetches the last saved location from device storage, or defaults to London
  Future<void> loadInitialTime() async {
    final prefs = await SharedPreferences.getInstance();
    final location = prefs.getString('location') ?? 'London';
    final url = prefs.getString('url') ?? 'Europe/London';
    
    // Trigger the update process with the loaded or default location
    await updateTime(WorldTime(location: location, url: url));
  }

  // The main method to fetch new time data for a given location
  Future<void> updateTime(WorldTime worldTime) async {
    _isLoading = true;
    _errorMessage = null;
    // Notify listeners to show a loading indicator on the UI
    notifyListeners();

    try {
      // Call the simplified 'getTime' method from the ApiService
      _currentTime = await _apiService.getTime(worldTime);

      // Save the newly selected location to device storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('location', _currentTime!.location);
      await prefs.setString('url', _currentTime!.url);

    } catch (e) {
      // If anything goes wrong, set an error message
      _errorMessage = 'Could not fetch time data. Please try again.';
      print(e); // For debugging purposes
    }
    
    _isLoading = false;
    // Notify listeners again to show the final data or the error message
    notifyListeners();
  }
}