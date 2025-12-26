import 'package:flutter/material.dart';
import '../../models/doa_model.dart';

class DoaDetailPage extends StatelessWidget {
  final DoaModel doa;

  const DoaDetailPage({Key? key, required this.doa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doa.judul)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Arab text - larger and styled
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  doa.arab,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 20),

              // Latin
              const Text(
                'Latin:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doa.latin,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),

              // Arti
              const Text(
                'Arti:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doa.arti,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Keywords/Tags
              if (doa.keywords.isNotEmpty) ...[
                const Text(
                  'Tags:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: doa.keywords.map((keyword) {
                    return Chip(
                      label:
                          Text(keyword, style: const TextStyle(fontSize: 12)),
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
