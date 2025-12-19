import 'package:flutter/material.dart';
import '../models/artikel.dart';
import '../services/artikel_service.dart';

class ArtikelDetailPage extends StatelessWidget {
  const ArtikelDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String artikelId =
        ModalRoute.of(context)!.settings.arguments as String;

    final ArtikelService service = ArtikelService();
    final Artikel? artikel = service.getById(artikelId);

    return Scaffold(
      appBar: AppBar(title: Text(artikel?.judul ?? 'Artikel')),
      body: artikel == null
          ? const Center(child: Text('Artikel tidak ditemukan'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  artikel.konten,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
    );
  }
}
