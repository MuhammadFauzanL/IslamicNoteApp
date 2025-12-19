import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const Color accentColor = Color(0xFF00ADB5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF222831),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _item(Icons.dashboard, 'Dashboard', 0),
          _item(Icons.article, 'Artikel', 1),
          _item(Icons.book, 'Doa', 2),
          _item(Icons.people, 'Users', 3),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, int index) {
    final bool active = index == selectedIndex;

    return ListTile(
      leading: Icon(icon, color: active ? accentColor : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: active ? accentColor : Colors.white70,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => onItemSelected(index),
    );
  }
}
