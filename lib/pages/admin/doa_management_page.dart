import 'package:flutter/material.dart';
import '../../models/doa_model.dart';
import '../../services/doa_service.dart';
import '../../services/auth_service.dart';
import '../../config/api_config.dart';
import 'package:http/http.dart' as http;
import 'doa_form_page.dart';

class DoaManagementPage extends StatefulWidget {
  const DoaManagementPage({Key? key}) : super(key: key);

  @override
  _DoaManagementPageState createState() => _DoaManagementPageState();
}

class _DoaManagementPageState extends State<DoaManagementPage> {
  List<DoaModel> _doaList = [];
  bool _isLoading = true;
  bool _isOffline = false;
  String? _cacheAge;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final online = await DoaService.hasInternet();
      final doaList = await DoaService.getAllDoa();
      final age = await DoaService.getCacheAge();

      if (!mounted) return;
      setState(() {
        _doaList = doaList;
        _isOffline = !online;
        _cacheAge = age;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _forceRefresh() async {
    if (!mounted) return;

    final online = await DoaService.hasInternet();
    if (!online) {
      if (mounted) {
        setState(() => _isOffline = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada koneksi internet'),
            backgroundColor: Color(0xFF00ADB5),
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final doaList = await DoaService.refreshDoa();
      final age = await DoaService.getCacheAge();

      if (!mounted) return;
      setState(() {
        _doaList = doaList;
        _isOffline = false;
        _cacheAge = age;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Doa berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteDoa(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF393E46),
        title: const Text('Hapus Doa', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Yakin ingin menghapus doa ini?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final headers = await AuthService.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.doaUrl}/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doa berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Doa'),
        actions: [
          if (_isOffline)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.cloud_off,
                color: themeColor,
                size: 20,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Perbarui Doa',
            onPressed: _isLoading ? null : _forceRefresh,
          ),
        ],
      ),
      body: _buildBody(isDark),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DoaFormPage(),
            ),
          );
          if (result == true) _loadData();
        },
        backgroundColor: const Color(0xFF00ADB5),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00ADB5)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (_cacheAge != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_doaList.length} doa',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (!_isOffline)
                  Text(
                    'Diperbarui: $_cacheAge',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _forceRefresh,
            child: ListView.builder(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 80),
              itemCount: _doaList.length,
              itemBuilder: (context, index) {
                final doa = _doaList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(
                      doa.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      doa.arab,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: isDark ? Colors.grey : Colors.grey[600],
                          fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Color(0xFF00ADB5)),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoaFormPage(doa: doa),
                              ),
                            );
                            if (result == true) _loadData();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteDoa(doa.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
