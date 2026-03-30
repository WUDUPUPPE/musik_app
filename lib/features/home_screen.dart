import 'package:flutter/material.dart';
import 'auth/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  const HomeScreen({super.key,
    required this.onToggleTheme,
    required this.themeMode,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Platzhalter-Widgets für die fünf Tabs
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home', style: TextStyle(fontSize: 20))),
    Center(child: Text('Favorites', style: TextStyle(fontSize: 20))),
    Center(child: Text('Erkennung', style: TextStyle(fontSize: 20))),
    Center(child: Text('Suchen', style: TextStyle(fontSize: 20))),
    Center(child: Text('Library', style: TextStyle(fontSize: 20))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await AuthService().signOut();
    // Durch authStateChanges() in main.dart fällt man automatisch auf WelcomeScreen zurück
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SONAR'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded   // Sonne → wechselt zu Light
                  : Icons.dark_mode_rounded,   // Mond  → wechselt zu Dark
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Erkennung',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Suchen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed, // wichtig für 5 Items
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}