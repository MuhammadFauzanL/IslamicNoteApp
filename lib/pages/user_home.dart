import 'package:flutter/material.dart';
import 'home/home.dart';
import 'doa/doa_list.dart';
import 'artikel/artikel_list.dart';
import 'chatbot/chatbot.dart';
import 'profile/profile_page.dart';

class UserHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const UserHomePage({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  final Color darkBgColor = const Color(0xFF222831);
  final Color darkAppBarColor = const Color(0xFF393E46);
  final Color accentColor = const Color(0xFF00ADB5);
  final Color lightBgColor = const Color(0xFFEEEEEE);

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      DoaListPage(),
      ArtikelListPage(),
      const ChatbotPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? darkBgColor : lightBgColor,
      appBar: AppBar(
        backgroundColor: isDark ? darkAppBarColor : accentColor,
        title: const Text('Islamic Note App'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                Switch(
                  value: isDark,
                  onChanged: (_) => widget.toggleTheme(),
                  activeColor: accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? darkBgColor : lightBgColor,
        selectedItemColor: accentColor,
        unselectedItemColor: isDark ? const Color(0xFFEEEEEE) : Colors.black54,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Doa"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Artikel"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chatbot"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
