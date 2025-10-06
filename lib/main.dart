import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/providers/auth_provider.dart';
import 'package:world_clock/providers/theme_provider.dart';
import 'package:world_clock/providers/time_provider.dart';
import 'package:world_clock/screens/choose_location_screen.dart';
import 'package:world_clock/screens/home_screen.dart';
import 'package:world_clock/screens/loading_screen.dart';
import 'package:world_clock/screens/login_screen.dart';
import 'package:world_clock/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TimeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'World Clock',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(backgroundColor: Colors.blue[900]),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[900],
              cardColor: Colors.grey[800],
              appBarTheme: AppBarTheme(backgroundColor: Colors.grey[850]),
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            themeMode: themeProvider.themeMode,
            // Use a custom home widget to decide the initial route
            home: const AuthWrapper(),
            routes: {
              // We no longer need an initialRoute, as AuthWrapper handles it
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/loading': (context) => const LoadingScreen(),
              '/home': (context) => const HomeScreen(),
              '/location': (context) => const ChooseLocationScreen(),
            },
          );
        },
      ),
    );
  }
}

// This widget is the new entry point of the app.
// It listens to the AuthProvider and decides which screen to show.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // While the provider is checking for a saved user, show a loading screen
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If a user is logged in (either saved or guest), show the LoadingScreen
    // which will then navigate to the HomeScreen.
    if (authProvider.user != null) {
      return const LoadingScreen();
    }

    // Otherwise, show the LoginScreen
    return const LoginScreen();
  }
}