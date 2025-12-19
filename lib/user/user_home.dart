// user/user_home.dart
import 'package:flutter/material.dart';

// ===== Feature Imports =====
import 'home/home_page.dart';
import 'doa/pages/doa_list_page.dart';
import 'artikel/pages/artikel_list_page.dart';
import 'chatbot/chatbot_page.dart';
import 'profile/profile_page.dart';

class UserHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const UserHomePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;

  // ===== Pages (User Area) =====
  late final List<Widget> _pages = const [
    HomePage(),
    DoaListPage(),
    ArtikelListPage(),
    ChatbotPage(),
    ProfilePage(),
  ];

  // ===== Theme Colors =====
  static const Color _darkBgColor = Color(0xFF222831);
  static const Color _darkAppBarColor = Color(0xFF393E46);
  static const Color _accentColor = Color(0xFF00ADB5);
  static const Color _lightBgColor = Color(0xFFEEEEEE);

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? _darkBgColor : _lightBgColor,
      appBar: _buildAppBar(isDark),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigation(isDark),
    );
  }

  // ===== AppBar =====
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? _darkAppBarColor : _accentColor,
      title: const Text('Islamic Note App'),
      actions: [
        Row(
          children: [
            Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            Switch(
              value: isDark,
              onChanged: (_) => widget.toggleTheme(),
              activeColor: _accentColor,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  // ===== Bottom Navigation =====
  Widget _buildBottomNavigation(bool isDark) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? _darkBgColor : _lightBgColor,
      selectedItemColor: _accentColor,
      unselectedItemColor: isDark ? Colors.white70 : Colors.black54,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Doa'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Artikel'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
