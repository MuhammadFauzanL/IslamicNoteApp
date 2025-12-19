import 'package:flutter/material.dart';
import '../models/doa_model.dart';
import '../services/doa_admin_service.dart';

class DoaFormPage extends StatefulWidget {
  final Doa? doa;

  const DoaFormPage({super.key, this.doa});

  @override
  State<DoaFormPage> createState() => _DoaFormPageState();
}

class _DoaFormPageState extends State<DoaFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _judulController;
  late TextEditingController _arabController;
  late TextEditingController _latinController;
  late TextEditingController _artiController;

  bool get isEdit => widget.doa != null;

  @override
  void initState() {
    super.initState();

    _judulController = TextEditingController(text: widget.doa?.judul ?? '');
    _arabController = TextEditingController(text: widget.doa?.arab ?? '');
    _latinController = TextEditingController(text: widget.doa?.latin ?? '');
    _artiController = TextEditingController(text: widget.doa?.arti ?? '');
  }

  @override
  void dispose() {
    _judulController.dispose();
    _arabController.dispose();
    _latinController.dispose();
    _artiController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (isEdit) {
      await DoaAdminService.updateDoa(
        id: widget.doa!.id,
        judul: _judulController.text.trim(),
        arab: _arabController.text.trim(),
        latin: _latinController.text.trim(),
        arti: _artiController.text.trim(),
      );
    } else {
      await DoaAdminService.createDoa(
        judul: _judulController.text.trim(),
        arab: _arabController.text.trim(),
        latin: _latinController.text.trim(),
        arti: _artiController.text.trim(),
      );
    }

    if (mounted) Navigator.pop(context, true);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Doa' : 'Tambah Doa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: _inputDecoration('Judul Doa'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _arabController,
                decoration: _inputDecoration('Teks Arab'),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Arab wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _latinController,
                decoration: _inputDecoration('Latin'),
                maxLines: 2,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Latin wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _artiController,
                decoration: _inputDecoration('Arti'),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Arti wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Doa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
