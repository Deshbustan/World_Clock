import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/models/world_time.dart';
import 'package:world_clock/providers/theme_provider.dart';
import 'package:world_clock/providers/time_provider.dart';
import 'package:world_clock/services/api_service.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  
  List<WorldTime> _allLocations = [];
  List<WorldTime> _filteredLocations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    // Add a listener to the search controller to filter the list in real-time
    _searchController.addListener(_filterLocations);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetches the full list of locations from the API
  Future<void> _fetchLocations() async {
    try {
      final locations = await _apiService.getLocations();
      if (mounted) {
        setState(() {
          _allLocations = locations;
          _filteredLocations = locations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // In a real app, you might want to show a SnackBar here
      print('Failed to load locations: $e');
    }
  }

  // Filters the location list based on the search query
  void _filterLocations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLocations = _allLocations.where((location) {
        return location.location.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Updates the app's state with the selected location
  void _updateLocation(BuildContext context, WorldTime location) {
    final timeProvider = Provider.of<TimeProvider>(context, listen: false);
    timeProvider.updateTime(location);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Get providers to determine the background and theme colors
    final timeProvider = context.watch<TimeProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    // Use the home screen's background image for thematic consistency
    final bgImage = timeProvider.currentTime?.isDayTime ?? true ? 'day.jpg' : 'night.jpg';

    return Scaffold(
      // Make the scaffold transparent to see the background container
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$bgImage'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar to be transparent
              AppBar(
                title: const Text('Choose a Location'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search for a city...',
                    hintStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                    prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
                    filled: true,
                    // Use a semi-transparent fill color that works in both modes
                    fillColor: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // LOCATION LIST
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : ListView.builder(
                        itemCount: _filteredLocations.length,
                        itemBuilder: (context, index) {
                          final location = _filteredLocations[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  location.location,
                                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                ),
                                onTap: () {
                                  _updateLocation(context, location);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}