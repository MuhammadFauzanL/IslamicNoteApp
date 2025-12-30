import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ChatbotGuard extends StatelessWidget {
  final Widget child;

  const ChatbotGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.data!) {
          Future.microtask(() async {
            final result =
                await Navigator.pushNamed(context, '/login');
            if (result == true && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => child),
              );
            }
          });

          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}
