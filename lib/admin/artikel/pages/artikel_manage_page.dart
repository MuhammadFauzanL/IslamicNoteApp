import 'package:flutter/material.dart';
import '../services/artikel_admin_service.dart';
import '../models/artikel_model.dart';
import 'artikel_form_page.dart';

class ArtikelManagePage extends StatefulWidget {
  const ArtikelManagePage({super.key});

  @override
  State<ArtikelManagePage> createState() => _ArtikelManagePageState();
}

class _ArtikelManagePageState extends State<ArtikelManagePage> {
  late Future<List<Artikel>> _futureArtikel;

  @override
  void initState() {
    super.initState();
    _futureArtikel = ArtikelAdminService.getAllArtikel();
  }

  void _refresh() {
    setState(() {
      _futureArtikel = ArtikelAdminService.getAllArtikel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Artikel')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ArtikelFormPage()),
          );
          _refresh();
        },
      ),
      body: FutureBuilder<List<Artikel>>(
        future: _futureArtikel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final artikel = data[index];
              return Card(
                child: ListTile(
                  title: Text(artikel.judul),
                  subtitle: Text(artikel.tanggal),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArtikelFormPage(artikel: artikel),
                            ),
                          );
                          _refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await ArtikelAdminService.deleteArtikel(artikel.id);
                          _refresh();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
