import 'package:flutter/material.dart';
import 'session_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SessionListScreen(),
    const PlaceholderWidget(title: "Duas", icon: Icons.insights),
    const PlaceholderWidget(title: "Hadiths", icon: Icons.people),
    const PlaceholderWidget(title: "Settings", icon: Icons.settings),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C1E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1A1C1E),
          selectedItemColor: const Color(0xFF2ECC71),
          unselectedItemColor: Colors.white24,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_add_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Sessions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_align_center_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Duas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp),
              activeIcon: Icon(Icons.group),
              label: 'Hadiths',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderWidget({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.white10),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white24),
          ),
          const SizedBox(height: 8),
          const Text(
            "Coming Soon",
            style: TextStyle(color: Colors.white10),
          ),
        ],
      ),
    );
  }
}
