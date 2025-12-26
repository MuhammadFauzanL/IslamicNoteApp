import 'package:flutter/material.dart';

/// Reusable error widget with retry functionality
class ErrorWidget extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final bool isOffline;

  const ErrorWidget({
    Key? key,
    required this.message,
    this.details,
    this.onRetry,
    this.isOffline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isOffline
                    ? Colors.orange.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                isOffline ? Icons.wifi_off : Icons.error_outline,
                size: 48,
                color: isOffline ? Colors.orange : Colors.red,
              ),
            ),
            const SizedBox(height: 24),

            // Error Title
            Text(
              isOffline ? 'Tidak Ada Koneksi' : 'Terjadi Kesalahan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Error Message
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            // Optional Details
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Retry Button
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ADB5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],

            // Offline hint
            if (isOffline) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Data cache tersedia',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget for when no data is available
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF00ADB5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                icon,
                size: 48,
                color: const Color(0xFF00ADB5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
