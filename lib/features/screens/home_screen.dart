import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musik_app/features/widgets/base_screen.dart';
import 'package:musik_app/features/auth/recognition_service.dart';
import 'package:musik_app/features/auth/song_result_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

const Color _navActiveColor = Color(0xFF7B2FBE);
const Color _navInactiveColor = Colors.white54;
const Color _navLabelActive = Color(0xFF7B2FBE);
const Color _navLabelInactive = Colors.white38;

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late int _selectedIndex = 0;
  bool _isListening = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ---- MUSIK-ERKENNUNG ----
  Future<void> _startRecognition() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mikrofon-Berechtigung fehlt!')),
        );
      }
      return;
    }
    setState(() => _isListening = true);
    _pulseController.repeat(reverse: true);

    final result = await RecognitionService.recognize();

    _pulseController.stop();
    _pulseController.reset();
    if (mounted) {
      setState(() => _isListening = false);
      if (result != null) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => SongResultSheet(song: result),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kein Song erkannt – versuch es nochmal!'),
            backgroundColor: Color(0xFF7B2FBE),
          ),
        );
      }
    }
  }

  // --- SCREENS ---
  static const List<Widget> _pages = [
    Center(child: Text('Home', style: TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold))),
    Center(child: Text('Favorites', style: TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold))),
    Center(child: Text('Erkennung', style: TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold))),
    Center(child: Text('Suchen', style: TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold))),
    Center(child: Text('Library', style: TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold))),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  Future<void> _logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.isAnonymous == true) {
      await user?.delete();
    } else {
      await FirebaseAuth.instance.signOut();
    }
  }

  // --- NAV ICON ---
  Widget _navIcon(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? _navActiveColor : _navInactiveColor, size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isSelected ? _navLabelActive : _navLabelInactive,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Stack(
        children: [
          // --- SEITEN-INHALT ---
          Positioned.fill(
            bottom: 90,
            child: _pages[_selectedIndex],
          ),

          // --- PROFIL & SETTINGS ---
          Positioned(
            top: 16,
            right: 26,
            child: GestureDetector(
              onTap: _logout,
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.teal.shade800.withValues(alpha: 0.8),
                        width: 2.3,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                          ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                          : null,
                      backgroundColor: Colors.teal.shade800.withValues(alpha: 0.23),
                      child: FirebaseAuth.instance.currentUser?.photoURL == null
                          ? const Icon(Icons.person, color: Colors.white, size: 24)
                          : null,
                    ),
                  ),
                  if (FirebaseAuth.instance.currentUser?.isAnonymous == true)
                    const Text(
                      'Gast',
                      style: TextStyle(fontSize: 9, color: Colors.white54),
                    ),
                ],
              ),
            ),
          ),

          // --- NAV-BAR ---
          Positioned(
            bottom: 6,
            left: 24,
            right: 24,
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navIcon(Icons.home_rounded, 'HOME', 0),
                  _navIcon(Icons.favorite_rounded, 'FAVORITES', 1),
                  GestureDetector(
                    onTap: _isListening ? null : _startRecognition,
                    child: AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, child) => Transform.scale(
                        scale: _isListening ? _pulseAnim.value : 1.0,
                        child: child,
                      ),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B2FBE), Color(0xFF4A0080)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withValues(alpha: _isListening ? 0.9 : 0.6),
                              blurRadius: _isListening ? 28 : 16,
                              spreadRadius: _isListening ? 6 : 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  _navIcon(Icons.search_rounded, 'SEARCH', 3),
                  _navIcon(Icons.library_music_rounded, 'LIBRARY', 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}