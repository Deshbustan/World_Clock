import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/providers/theme_provider.dart';
import 'package:world_clock/providers/time_provider.dart';
import 'package:world_clock/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeProvider = context.watch<TimeProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    // Get the AuthProvider to check if the user is a guest
    final authProvider = context.watch<AuthProvider>();

    if (timeProvider.isLoading && timeProvider.currentTime == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (timeProvider.errorMessage != null) {
      return Scaffold(body: Center(child: Text(timeProvider.errorMessage!)));
    }

    final currentTime = timeProvider.currentTime!;
    final bgImage = currentTime.isDayTime ? 'day.jpg' : 'night.jpg';
    final textColor = themeProvider.isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$bgImage'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/location'),
                      icon: Icon(Icons.edit_location, color: textColor),
                      label: Text('Edit Location', style: TextStyle(color: textColor)),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            themeProvider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            color: textColor,
                          ),
                          onPressed: () {
                            context.read<ThemeProvider>().toggleTheme();
                          },
                        ),
                        const SizedBox(width: 10),
                        // Only show the Logout button if the user is NOT a guest
                        if (!authProvider.isGuest)
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthProvider>().logout();
                              // The AuthWrapper will handle navigating back to the login screen
                            },
                            child: const Text('Logout'),
                          ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  currentTime.location,
                  style: TextStyle(fontSize: 32.0, letterSpacing: 2.0, color: textColor),
                ),
                const SizedBox(height: 20.0),
                Text(
                  currentTime.time,
                  style: TextStyle(fontSize: 66.0, fontWeight: FontWeight.bold, color: textColor),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}