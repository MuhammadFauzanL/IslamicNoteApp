import 'package:flutter/material.dart';

import 'home/home.dart';
import 'doa/doa_list.dart';
import 'artikel/artikel_list.dart';
import 'chatbot/chatbot.dart';
import 'profile/profile_page.dart';
import '../services/auth_service.dart';
import '../core/auth_state.dart'; // ✅ WAJIB: Import ini agar authStateNotifier terbaca

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

  // 🔥 KEY UNTUK MERESET HALAMAN
  // Key ini yang akan "membunuh" state lama saat logout
  Key _scaffoldKey = UniqueKey();
  Key _doaKey = UniqueKey();
  Key _artikelKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // ✅ DENGARKAN PERUBAHAN LOGIN/LOGOUT GLOBAL
    authStateNotifier.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    // ✅ BERSIHKAN LISTENER AGAR TIDAK MEMORI LEAK
    authStateNotifier.removeListener(_onAuthChanged);
    super.dispose();
  }

  // 🔥 FUNGSI REFRESH TOTAL
  // Dipanggil otomatis saat authStateNotifier berubah (Login/Logout)
  void _onAuthChanged() {
    if (!mounted) return;

    setState(() {
      // 1. Reset Key Scaffold (Refresh seluruh struktur halaman)
      _scaffoldKey = UniqueKey(); 
      
      // 2. Reset Key Halaman Anak (Refresh isi Doa & Artikel)
      _doaKey = UniqueKey();
      _artikelKey = UniqueKey();
      
      // 3. Kembalikan ke Home agar user tidak bingung
      _currentIndex = 0; 
    });
    
    print("🔄 UI Direset Total karena status Login berubah");
  }

  final Color darkBgColor = const Color(0xFF222831);
  final Color lightBgColor = const Color(0xFFEEEEEE);
  final Color accentColor = const Color(0xFF00ADB5);

  // =========================
  // PAGES CONFIGURATION
  // =========================
  List<Widget> get _pages => [
        // Index 0: Home
        HomePage(
          isDarkMode: widget.isDarkMode,
          onTabChange: _switchTab,
        ),
        
        // Index 1: Doa List (Pasang Key di sini!)
        DoaListPage(key: _doaKey),
        
        // Index 2: Artikel List (Pasang Key di sini!)
        ArtikelListPage(key: _artikelKey),

        // Index 3: Chatbot (Placeholder, karena dibuka via push)
        const SizedBox.shrink(),

        // Index 4: Profile
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
      // Optional: Refresh juga saat tombol home ditekan
      if (index == 1) _doaKey = UniqueKey();
      if (index == 2) _artikelKey = UniqueKey();
    });
  }

  // =========================
  // BOTTOM NAV HANDLER
  // =========================
  Future<void> _onTabTapped(int index) async {
    // ================= CHATBOT (INDEX 3) =================
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
          // Trigger manual update state jika perlu
          _onAuthChanged(); 
          
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
      key: _scaffoldKey, // 🔥 KEY UTAMA DIPASANG DI SINI
      backgroundColor: isDark ? darkBgColor : lightBgColor,
      
      // IndexedStack menjaga halaman tetap hidup, 
      // tapi _doaKey yang berubah akan memaksanya mati dan hidup ulang.
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