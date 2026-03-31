import 'package:flutter/material.dart';
import 'surah_list_screen.dart';
import 'juz_screen.dart';
import 'bookmarks_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book,
      label: 'Surahs',
    ),
    _NavItem(
      icon: Icons.format_list_numbered_outlined,
      activeIcon: Icons.format_list_numbered,
      label: 'Juz',
    ),
    _NavItem(
      icon: Icons.bookmark_outline,
      activeIcon: Icons.bookmark,
      label: 'Bookmarks',
    ),
    _NavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
    ),
  ];

  final List<Widget> _screens = const [
    SurahListScreen(),
    JuzScreen(),
    BookmarksScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: _navItems
            .map((item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.activeIcon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
