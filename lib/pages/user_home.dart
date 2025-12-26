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
  // Keys to force rebuild when switching tabs
  Key _doaKey = UniqueKey();
  Key _artikelKey = UniqueKey();

  final Color darkBgColor = const Color(0xFF222831);
  final Color darkAppBarColor = const Color(0xFF393E46);
  final Color accentColor = const Color(0xFF00ADB5);
  final Color lightBgColor = const Color(0xFFEEEEEE);

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
      // Refresh keys to force admin check
      _doaKey = UniqueKey();
      _artikelKey = UniqueKey();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Refresh keys when manually switching tabs
      if (index == 1) _doaKey = UniqueKey();
      if (index == 2) _artikelKey = UniqueKey();
    });
  }

  List<Widget> get _pages => [
        HomePage(
          isDarkMode: widget.isDarkMode,
          onTabChange: _switchTab,
        ),
        DoaListPage(key: _doaKey),
        ArtikelListPage(key: _artikelKey),
        const ChatbotPage(),
        ProfilePage(
          toggleTheme: widget.toggleTheme,
          isDarkMode: widget.isDarkMode,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? darkBgColor : lightBgColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? darkBgColor : lightBgColor,
        selectedItemColor: accentColor,
        unselectedItemColor: isDark ? const Color(0xFFEEEEEE) : Colors.black54,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
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
