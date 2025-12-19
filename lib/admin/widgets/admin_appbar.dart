import 'package:flutter/material.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF393E46),
      title: const Text('Admin Panel'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // nanti: logout logic
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
