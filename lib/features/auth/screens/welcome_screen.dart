import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'sonar_background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF05020B),
              Color(0xFF1B0929),
              Color(0xFF1B102C),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [

              // ---- ANIMATED SONAR HINTERGRUND ----
              Positioned.fill(
                child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const ['S', 'O', 'N', 'A', 'R'].map((letter) => Text(letter,
                  style: TextStyle(
                    fontSize: 180,
                    fontWeight: FontWeight.w900,
                    height: 0.85,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color(0xE8310B47), // Dunkles Purple oben
                          Color(0xEC140325), // Tiefes Violet unten
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 200)),
                    shadows: const [
                      // 3D-Kante (helles Lila, scharf)
                      Shadow(
                        color: Color(0xFF6A30A8),
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                      // Tiefe (dunkles Violet, scharf)
                      Shadow(
                        color: Color(0xD51C3028),
                        offset: Offset(7, 7),
                        blurRadius: 1,
                      ),
                      // Innerer Glow
                      Shadow(
                        color: Color(0xD519513C),
                        offset: Offset(0, 0),
                        blurRadius: 10,
                      ),
                      // Äußerer Glow (weich, breit)
                      Shadow(
                        color: Color(0xD84E1D7C),
                        offset: Offset(-1, -1),
                        blurRadius: 22,
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),

              // ---- HAUPT-INHALT ----
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      'Well, that´s what you need',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Erkenne Songs in deiner Umgebung '
                          'und speichere sie in ....',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB0A8D0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Anmelden'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text('Registrieren'),
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
