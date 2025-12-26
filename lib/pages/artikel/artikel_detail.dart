import 'package:flutter/material.dart';
import '../../models/artikel_model.dart';

class ArtikelDetailPage extends StatelessWidget {
  final ArtikelModel artikel;

  const ArtikelDetailPage({Key? key, required this.artikel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artikel.judul),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              artikel.judul,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Meta info
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    artikel.kategori,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  artikel.penulis,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date
            if (artikel.createdAt != null)
              Text(
                'Dipublikasikan: ${_formatDate(artikel.createdAt!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),

            // Ringkasan
            if (artikel.ringkasan.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 4,
                    ),
                  ),
                ),
                child: Text(
                  artikel.ringkasan,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Konten
            Text(
              artikel.konten,
              style: const TextStyle(
                fontSize: 16,
                height: 1.8,
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
