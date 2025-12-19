import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color _accentColor = Color(0xFF00ADB5);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          const CircleAvatar(
            radius: 55,
            backgroundColor: _accentColor,
            child: Icon(Icons.person, size: 55, color: Colors.white),
          ),

          const SizedBox(height: 16),

          // Nama User
          const Text(
            'Nama Pengguna',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          // Email
          const Text(
            'user@email.com',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),

          const SizedBox(height: 24),

          // Card Menu
          _profileMenu(
            icon: Icons.edit,
            title: 'Edit Profil',
            onTap: () {
              // TODO: navigasi ke edit profile
            },
          ),

          _profileMenu(
            icon: Icons.lock,
            title: 'Ganti Password',
            onTap: () {
              // TODO: ganti password
            },
          ),

          _profileMenu(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Islamic Note App',
                applicationVersion: '1.0.0',
              );
            },
          ),

          const SizedBox(height: 16),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: logout logic
            },
          ),
        ],
      ),
    );
  }

  Widget _profileMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: _accentColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
