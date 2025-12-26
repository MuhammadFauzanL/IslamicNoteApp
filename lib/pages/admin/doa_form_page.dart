import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/doa_model.dart';
import '../../services/auth_service.dart';
import '../../config/api_config.dart';

class DoaFormPage extends StatefulWidget {
  final DoaModel? doa;

  const DoaFormPage({Key? key, this.doa}) : super(key: key);

  @override
  _DoaFormPageState createState() => _DoaFormPageState();
}

class _DoaFormPageState extends State<DoaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _judulController;
  late TextEditingController _arabController;
  late TextEditingController _latinController;
  late TextEditingController _artiController;
  late TextEditingController _keywordsController;
  bool _isLoading = false;

  bool get isEdit => widget.doa != null;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.doa?.label ?? '');
    _judulController = TextEditingController(text: widget.doa?.judul ?? '');
    _arabController = TextEditingController(text: widget.doa?.arab ?? '');
    _latinController = TextEditingController(text: widget.doa?.latin ?? '');
    _artiController = TextEditingController(text: widget.doa?.arti ?? '');
    _keywordsController = TextEditingController(
      text: widget.doa?.keywords.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _judulController.dispose();
    _arabController.dispose();
    _latinController.dispose();
    _artiController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  Future<void> _saveDoa() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final headers = await AuthService.getAuthHeaders();
      final body = json.encode({
        'label': _labelController.text.trim(),
        'judul': _judulController.text.trim(),
        'arab': _arabController.text.trim(),
        'latin': _latinController.text.trim(),
        'arti': _artiController.text.trim(),
        'keywords': _keywordsController.text
            .split(',')
            .map((k) => k.trim())
            .where((k) => k.isNotEmpty)
            .toList(),
      });

      final response = isEdit
          ? await http.put(
              Uri.parse('${ApiConfig.doaUrl}/${widget.doa!.id}'),
              headers: headers,
              body: body,
            )
          : await http.post(
              Uri.parse(ApiConfig.doaUrl),
              headers: headers,
              body: body,
            );

      setState(() => _isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit
                ? 'Doa berhasil diperbarui'
                : 'Doa berhasil ditambahkan'),
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
          isEdit ? 'Edit Doa' : 'Tambah Doa',
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
                controller: _labelController,
                label: 'Label',
                hint: 'DOA_HUJAN',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: _judulController,
                label: 'Judul',
                hint: 'Doa Saat Hujan',
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: _arabController,
                label: 'Teks Arab',
                hint: 'اللَّهُمَّ...',
                maxLines: 3,
                required: true,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: _latinController,
                label: 'Latin',
                hint: 'Allahumma...',
                maxLines: 2,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: _artiController,
                label: 'Arti',
                hint: 'Ya Allah...',
                maxLines: 3,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: _keywordsController,
                label: 'Keywords (pisahkan dengan koma)',
                hint: 'hujan, air, rintik',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveDoa,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00ADB5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEdit ? 'Simpan Perubahan' : 'Tambah Doa',
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
    TextDirection? textDirection,
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
          textDirection: textDirection,
          style: TextStyle(
            fontSize: textDirection == TextDirection.rtl ? 18 : 14,
          ),
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
