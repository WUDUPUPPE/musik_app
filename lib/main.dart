import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // WICHTIG: Widgets müssen initialisiert sein, bevor Firebase startet
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase mit den generierten Optionen initialisieren
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SonarApp());
}

class SonarApp extends StatelessWidget {
  const SonarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SONAR App',
      // Dein App-Theme (Farben kannst du später anpassen)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Hier testen wir gleich, ob die Bottom-Navigation funktioniert
  int _selectedIndex = 0;

  // Später packen wir hier die echten Screens rein
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Screen (Firebase ist verbunden!)', style: TextStyle(fontSize: 20)),
    Text('Favorites Screen', style: TextStyle(fontSize: 20)),
    Text('Erkennung (Mikrofon)', style: TextStyle(fontSize: 20)),
    Text('Suchen Screen', style: TextStyle(fontSize: 20)),
    Text('Library / History', style: TextStyle(fontSize: 20)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SONAR'),
      ),
      body: Center(
        // Zeigt den Text passend zum ausgewählten Tab an
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Erkennung'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Suchen'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
        ],
        currentIndex: _selectedIndex,
        // Sorgt dafür, dass alle 5 Items Platz haben und ihre Farbe behalten
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
