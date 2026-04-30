import 'package:flutter/material.dart';
import 'tarot_reading_screen.dart';
import 'astrology_input_screen.dart';
import 'daily_horoscope_screen.dart';
import 'saved_readings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TarotReadingScreen(),
    const AstrologyInputScreen(),
    const DailyHoroscopeScreen(),
    const SavedReadingsScreen(),
  ];

  final List<String> _titles = [
    'Tarot-læsning',
    'Fødselsdata & Astrologi',
    'Dagens Horoskop',
    'Gemte Læsninger',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.style), label: 'Tarot'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Astrologi'),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Horoskop'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historik'),
        ],
      ),
    );
  }
}
