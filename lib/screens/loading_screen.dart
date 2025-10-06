import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/providers/time_provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // This ensures the code runs after the widget has been built,
    // so we can safely access the context.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initClock());
  }

  void _initClock() {
    // We listen for when the TimeProvider finishes its initial loading.
    // The actual data fetching is triggered when the provider is first created.
    final timeProvider = context.read<TimeProvider>();

    // If the data is already loaded (e.g., if this screen were ever revisited),
    // navigate immediately.
    if (!timeProvider.isLoading) {
      _navigateToHome();
    } else {
      // Otherwise, add a listener that will be called when the provider's state changes.
      timeProvider.addListener(_onTimeProviderChange);
    }
  }

  void _onTimeProviderChange() {
    // Check if the provider is no longer loading and if the screen is still active ('mounted').
    if (!context.read<TimeProvider>().isLoading && mounted) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    // Use pushReplacementNamed to prevent the user from navigating back to the loading screen.
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    // It's crucial to remove the listener in the dispose method
    // to prevent memory leaks and errors.
    context.read<TimeProvider>().removeListener(_onTimeProviderChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: const Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}