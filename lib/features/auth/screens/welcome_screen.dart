import 'package:flutter/material.dart';
import '../../../widgets/base_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Well, that´s what you need',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Erkenne Songs in deiner Umgebung und speichere sie in ....',
              style: TextStyle(fontSize: 16, color: Color(0xFFB0A8D0)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const LoginScreen())),
                      child: const Text('Anmelden'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: const Text('Registrieren'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
