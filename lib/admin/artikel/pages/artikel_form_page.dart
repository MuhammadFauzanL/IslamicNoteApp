import 'package:flutter/material.dart';
import '../models/artikel_model.dart';
import '../services/artikel_admin_service.dart';

class ArtikelFormPage extends StatefulWidget {
  final Artikel? artikel;

  const ArtikelFormPage({super.key, this.artikel});

  @override
  State<ArtikelFormPage> createState() => _ArtikelFormPageState();
}

class _ArtikelFormPageState extends State<ArtikelFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judul;
  late TextEditingController _konten;

  @override
  void initState() {
    super.initState();
    _judul = TextEditingController(text: widget.artikel?.judul ?? '');
    _konten = TextEditingController(text: widget.artikel?.konten ?? '');
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (widget.artikel == null) {
        await ArtikelAdminService.createArtikel(
          judul: _judul.text,
          konten: _konten.text,
        );
      } else {
        await ArtikelAdminService.updateArtikel(
          id: widget.artikel!.id,
          judul: _judul.text,
          konten: _konten.text,
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artikel == null ? 'Tambah Artikel' : 'Edit Artikel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judul,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) => v!.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _konten,
                decoration: const InputDecoration(labelText: 'Konten'),
                maxLines: 5,
                validator: (v) => v!.isEmpty ? 'Konten wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
