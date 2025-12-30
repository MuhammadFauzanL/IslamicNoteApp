import 'package:flutter/material.dart';

import 'home/home.dart';
import 'doa/doa_list.dart';
import 'artikel/artikel_list.dart';
import 'chatbot/chatbot.dart';
import 'profile/profile_page.dart';
import '../services/auth_service.dart';

class UserHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const UserHomePage({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;

  Key _doaKey = UniqueKey();
  Key _artikelKey = UniqueKey();

  final Color darkBgColor = const Color(0xFF222831);
  final Color lightBgColor = const Color(0xFFEEEEEE);
  final Color accentColor = const Color(0xFF00ADB5);

  // =========================
  // PAGES (CHATBOT TIDAK DI SINI)
  // =========================
  List<Widget> get _pages => [
        HomePage(
          isDarkMode: widget.isDarkMode,
          onTabChange: _switchTab,
        ),
        DoaListPage(key: _doaKey),
        ArtikelListPage(key: _artikelKey),

        // ⛔ INDEX 3 DIKOSONGKAN (CHATBOT VIA NAVIGATOR)
        const SizedBox.shrink(),

        ProfilePage(
          toggleTheme: widget.toggleTheme,
          isDarkMode: widget.isDarkMode,
        ),
      ];

  // =========================
  // SWITCH TAB (HOME BUTTON)
  // =========================
  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) _doaKey = UniqueKey();
      if (index == 2) _artikelKey = UniqueKey();
    });
  }

  // =========================
  // BOTTOM NAV HANDLER
  // =========================
  Future<void> _onTabTapped(int index) async {
    // ================= CHATBOT =================
    if (index == 3) {
      final loggedIn = await AuthService.isLoggedIn();
      if (!mounted) return;

      // 🔒 BELUM LOGIN
      if (!loggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Untuk mencoba chatbot, silakan login terlebih dahulu',
            ),
          ),
        );

        final result = await Navigator.pushNamed(context, '/login');

        // ✅ LOGIN BERHASIL → BUKA CHATBOT
        if (result == true && mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ChatbotPage(),
            ),
          );
        }

        return;
      }

      // ✅ SUDAH LOGIN → LANGSUNG CHATBOT
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ChatbotPage(),
        ),
      );

      return;
    }

    // ================= TAB NORMAL =================
    setState(() {
      _currentIndex = index;
    });
  }

  // =========================
  // BUILD
  // =========================
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
        unselectedItemColor:
            isDark ? const Color(0xFFEEEEEE) : Colors.black54,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Doa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: "Artikel",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chatbot",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
