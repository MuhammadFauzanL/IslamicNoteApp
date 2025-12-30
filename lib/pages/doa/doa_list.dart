import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/doa_service.dart';
import '../../services/auth_service.dart';
import '../../models/doa_model.dart';
import 'doa_detail.dart';
import '../admin/doa_management_page.dart';

class DoaListPage extends StatefulWidget {
  const DoaListPage({Key? key}) : super(key: key);

  

  @override
  _DoaListPageState createState() => _DoaListPageState();
}

class _DoaListPageState extends State<DoaListPage> {
  List<DoaModel> allDoa = [];
  List<DoaModel> filteredDoa = [];
  Set<String> favoriteDoas = {};
  TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  bool isAdmin = false;
  bool isOffline = false;
  String? cacheAge;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initData();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAdmin();
  }

  Future<void> _initData() async {
    await _checkAdmin();
    await _loadData();
  }

  Future<void> _checkAdmin() async {
    final admin = await AuthService.isAdmin();
    if (mounted) {
      setState(() => isAdmin = admin);
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      favoriteDoas = prefs.getStringList('favoriteDoas')?.toSet() ?? {};

      final online = await DoaService.hasInternet();
      final doaList = await DoaService.getAllDoa();
      final age = await DoaService.getCacheAge();

      if (!mounted) return;
      setState(() {
        allDoa = doaList;
        _updateFilteredDoa('');
        isOffline = !online;
        cacheAge = age;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _forceRefresh() async {
    if (!mounted) return;

    final online = await DoaService.hasInternet();
    if (!online) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada koneksi internet'),
          backgroundColor: Color(0xFF00ADB5),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final doaList = await DoaService.refreshDoa();
      final age = await DoaService.getCacheAge();

      if (!mounted) return;
      setState(() {
        allDoa = doaList;
        _updateFilteredDoa(searchController.text);
        isOffline = false;
        cacheAge = age;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Doa berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleFavorite(DoaModel doa) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (favoriteDoas.contains(doa.id)) {
        favoriteDoas.remove(doa.id);
      } else {
        favoriteDoas.add(doa.id);
      }

      prefs.setStringList('favoriteDoas', favoriteDoas.toList());
      _updateFilteredDoa(searchController.text);
    });
  }

  void _updateFilteredDoa(String query) {
    final filtered = allDoa.where((doa) {
      return doa.judul.toLowerCase().contains(query.toLowerCase()) ||
          doa.arti.toLowerCase().contains(query.toLowerCase());
    }).toList();

    filtered.sort((a, b) {
      final aFav = favoriteDoas.contains(a.id);
      final bFav = favoriteDoas.contains(b.id);
      if (aFav && !bFav) return -1;
      if (!aFav && bFav) return 1;
      return a.judul.compareTo(b.judul);
    });

    setState(() => filteredDoa = filtered);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Doa'),
        automaticallyImplyLeading: false,
        actions: [
          if (isOffline)
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
            onPressed: isLoading ? null : _forceRefresh,
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.edit_note),
              tooltip: 'Kelola Doa',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DoaManagementPage(),
                  ),
                );
                _loadData();
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Cari doa...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _updateFilteredDoa,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filteredDoa.length} doa',
                style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 73, 73, 73)),
              ),
              if (!isOffline && cacheAge != null)
                Text(
                  'Diperbarui: $cacheAge',
                  style: const TextStyle(fontSize: 11, color: Color.fromARGB(255, 43, 43, 43)),
                ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _forceRefresh,
            child: filteredDoa.isEmpty
                ? const Center(child: Text('Tidak ada doa ditemukan'))
                : ListView.builder(
                    itemCount: filteredDoa.length,
                    itemBuilder: (context, index) {
                      final doa = filteredDoa[index];
                      final isFav = favoriteDoas.contains(doa.id);

                      return ListTile(
                        title: Text(doa.judul),
                        subtitle: Text(
                          doa.arti,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFav ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(doa),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoaDetailPage(doa: doa),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
