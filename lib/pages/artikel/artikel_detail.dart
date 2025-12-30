import 'package:flutter/material.dart';
import '../../models/artikel_model.dart';

class ArtikelDetailPage extends StatelessWidget {
  final ArtikelModel artikel;

  const ArtikelDetailPage({Key? key, required this.artikel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(artikel.judul),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== JUDUL =====
            Text(
              artikel.judul,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 12),

            /// ===== META INFO =====
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    artikel.kategori,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.person_outline,
                    size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  artikel.penulis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// ===== TANGGAL =====
            if (artikel.createdAt != null)
              Text(
                'Dipublikasikan: ${_formatDate(artikel.createdAt!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

            const SizedBox(height: 20),
            Divider(color: colorScheme.outline.withOpacity(0.3)),
            const SizedBox(height: 16),

            /// ===== RINGKASAN =====
            if (artikel.ringkasan.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                      color: colorScheme.primary,
                      width: 4,
                    ),
                  ),
                ),
                child: Text(
                  artikel.ringkasan,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// ===== KONTEN =====
            Text(
              artikel.konten,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.8,
                color: colorScheme.onBackground,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
