import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
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
  Set<int> favoriteDoas = {};
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String? errorMessage;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAdmin(); // Re-check admin status when page becomes visible again
  }

  Future<void> _initData() async {
    await _checkAdmin();
    _loadData();
  }

  Future<void> _checkAdmin() async {
    final admin = await AuthService.isAdmin();
    if (mounted && admin != isAdmin) {
      setState(() {
        isAdmin = admin;
      });
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Load favorites from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favoriteDoas') ?? [];
      favoriteDoas = favoriteIds.map((id) => int.tryParse(id) ?? 0).toSet();

      // Fetch doa from API
      final doaList = await ApiService.getAllDoa();

      if (!mounted) return;
      setState(() {
        allDoa = doaList;
        _updateFilteredDoa('');
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(DoaModel doa) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteDoas.contains(doa.id)) {
        favoriteDoas.remove(doa.id);
      } else {
        favoriteDoas.add(doa.id);
      }
      prefs.setStringList(
          'favoriteDoas', favoriteDoas.map((id) => id.toString()).toList());
      _updateFilteredDoa(searchController.text);
    });
  }

  void _updateFilteredDoa(String query) {
    List<DoaModel> filtered = allDoa.where((doa) {
      final matchJudul = doa.judul.toLowerCase().contains(query.toLowerCase());
      final matchArti = doa.arti.toLowerCase().contains(query.toLowerCase());
      return matchJudul || matchArti;
    }).toList();

    // Sort: favorites first
    filtered.sort((a, b) {
      bool aFav = favoriteDoas.contains(a.id);
      bool bFav = favoriteDoas.contains(b.id);
      if (aFav && !bFav) return -1;
      if (!aFav && bFav) return 1;
      return a.judul.compareTo(b.judul);
    });

    setState(() {
      filteredDoa = filtered;
    });
  }

  void _filterDoa(String query) {
    _updateFilteredDoa(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Doa'),
        automaticallyImplyLeading: false,
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.edit_note),
              tooltip: 'Kelola Doa',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DoaManagementPage()),
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat doa...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Cari doa...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _filterDoa,
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              itemCount: filteredDoa.length,
              itemBuilder: (context, index) {
                final doa = filteredDoa[index];
                final isFavorite = favoriteDoas.contains(doa.id);
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
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(doa),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoaDetailPage(doa: doa),
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
