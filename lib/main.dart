import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'features/auth/services/auth_service.dart';
import 'features/auth/screens/welcome_screen.dart';
import 'home_screen.dart';

// ---- APP START ----
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const SonarApp());
}

// ---- ROOT WIDGETS (STATEFUL FÜR THEMEMODE-TOGGLE) ----
class SonarApp extends StatefulWidget {
  const SonarApp({super.key});

  static _SonarAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_SonarAppState>();
  @override
  State<SonarApp> createState() => _SonarAppState();
}

class _SonarAppState extends State<SonarApp> {
  // --- AuthService einmal erstellen ---
  final authService = AuthService();

  // --- ThemeMode-State tauscht light/dark ---
  ThemeMode _themeMode = ThemeMode.system;

  // --- DarkMode Toggle ---
  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SONAR',
      debugShowCheckedModeBanner: false,
      // ← kein "DEBUG"-Banner
      // --- ThemeMode ---
      themeMode: _themeMode,
      // --- LightTheme ---
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6C63FF), brightness: Brightness.light,),
      ),
      // --- DarkTheme ---
      darkTheme: ThemeData(
        useMaterial3: true, colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark,),
      ),

      // ---- AUTH-GATE: SCREEN_USE ----
      home: StreamBuilder(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          // --- Ladezustand (Firebase prüft) ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // --- Eingeloggt -> HomeScreen ---
          if (snapshot.hasData) {
            return HomeScreen(
                onToggleTheme: _toggleTheme, themeMode: _themeMode);
          }
          // --- nicht eingeloggt -> WelcomeScreen ---
          return const WelcomeScreen();
        },
      ),
    );
  }
}