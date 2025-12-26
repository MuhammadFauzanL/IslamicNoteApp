import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/artikel_model.dart';
import '../../services/auth_service.dart';
import '../../config/api_config.dart';

class ArtikelFormPage extends StatefulWidget {
  final ArtikelModel? artikel;

  const ArtikelFormPage({Key? key, this.artikel}) : super(key: key);

  @override
  _ArtikelFormPageState createState() => _ArtikelFormPageState();
}

class _ArtikelFormPageState extends State<ArtikelFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _ringkasanController;
  late TextEditingController _kontenController;
  late TextEditingController _kategoriController;
  late TextEditingController _penulisController;
  bool _isLoading = false;

  bool get isEdit => widget.artikel != null;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.artikel?.judul ?? '');
    _ringkasanController =
        TextEditingController(text: widget.artikel?.ringkasan ?? '');
    _kontenController =
        TextEditingController(text: widget.artikel?.konten ?? '');
    _kategoriController =
        TextEditingController(text: widget.artikel?.kategori ?? '');
    _penulisController =
        TextEditingController(text: widget.artikel?.penulis ?? 'Admin');
  }

  @override
  void dispose() {
    _judulController.dispose();
    _ringkasanController.dispose();
    _kontenController.dispose();
    _kategoriController.dispose();
    _penulisController.dispose();
    super.dispose();
  }

  Future<void> _saveArtikel() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final headers = await AuthService.getAuthHeaders();
      final body = json.encode({
        'judul': _judulController.text.trim(),
        'ringkasan': _ringkasanController.text.trim(),
        'konten': _kontenController.text.trim(),
        'kategori': _kategoriController.text.trim(),
        'penulis': _penulisController.text.trim(),
      });

      final response = isEdit
          ? await http.put(
              Uri.parse('${ApiConfig.artikelUrl}/${widget.artikel!.id}'),
              headers: headers,
              body: body,
            )
          : await http.post(
              Uri.parse(ApiConfig.artikelUrl),
              headers: headers,
              body: body,
            );

      setState(() => _isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit
                ? 'Artikel berhasil diperbarui'
                : 'Artikel berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Gagal menyimpan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Artikel' : 'Tambah Artikel',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                context: context,
                controller: _judulController,
                label: 'Judul',
                hint: 'Judul artikel',
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: _kategoriController,
                label: 'Kategori',
                hint: 'Ibadah, Sholat, Puasa, dll',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: _ringkasanController,
                label: 'Ringkasan',
                hint: 'Ringkasan singkat artikel...',
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: _kontenController,
                label: 'Konten',
                hint: 'Isi artikel lengkap...',
                maxLines: 10,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: _penulisController,
                label: 'Penulis',
                hint: 'Nama penulis',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveArtikel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00ADB5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEdit ? 'Simpan Perubahan' : 'Tambah Artikel',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    bool required = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (required ? ' *' : ''),
          style: const TextStyle(
              color: Color(0xFF00ADB5), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(color: isDark ? Colors.grey : Colors.grey[500]),
            filled: true,
            fillColor: isDark ? const Color(0xFF393E46) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF00ADB5)),
            ),
          ),
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label wajib diisi';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
