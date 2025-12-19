// admin/admin_home.dart
import 'package:flutter/material.dart';

import 'users/user_manage_page.dart';
import 'doa/pages/doa_manage_page.dart';
import 'artikel/pages/artikel_manage_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  static const Color accentColor = Color(0xFF00ADB5);
  static const Color darkBgColor = Color(0xFF222831);
  static const Color darkCardColor = Color(0xFF393E46);

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: darkCardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: accentColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBgColor,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: darkCardColor,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          _buildMenuCard(
            context: context,
            icon: Icons.people,
            title: 'Manajemen User',
            subtitle: 'Aktifkan, nonaktifkan, atau hapus user',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserManagePage()),
              );
            },
          ),

          _buildMenuCard(
            context: context,
            icon: Icons.menu_book,
            title: 'Manajemen Doa',
            subtitle: 'Tambah, edit, dan hapus doa',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoaManagePage()),
              );
            },
          ),

          _buildMenuCard(
            context: context,
            icon: Icons.article,
            title: 'Manajemen Artikel',
            subtitle: 'Kelola konten artikel islami',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArtikelManagePage()),
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
