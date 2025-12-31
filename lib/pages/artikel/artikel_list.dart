import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/artikel_service.dart';
import '../../services/auth_service.dart';
import '../../models/artikel_model.dart';
import 'artikel_detail.dart';
import '../admin/artikel_management_page.dart';

class ArtikelListPage extends StatefulWidget {
  const ArtikelListPage({Key? key}) : super(key: key);

  @override
  _ArtikelListPageState createState() => _ArtikelListPageState();
}

class _ArtikelListPageState extends State<ArtikelListPage> {
  List<ArtikelModel> allArtikel = [];
  List<ArtikelModel> filteredArtikel = [];
  Set<int> favoriteArtikels = {};
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String? errorMessage;
  bool isAdmin = false;
  bool isOffline = false;
  String? cacheAge;
  String _favoriteKey =
      'favoriteArtikels_guest'; // Will be updated with user ID

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
      // Load favorites from local storage (per user)
      final user = await AuthService.getStoredUser();
      final userId = user?.id.toString() ?? 'guest';
      _favoriteKey = 'favoriteArtikels_user_$userId';

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload(); // Force reload from disk
      final favoriteIds = prefs.getStringList(_favoriteKey) ?? [];
      favoriteArtikels = favoriteIds.map((id) => int.tryParse(id) ?? 0).toSet();

      // Check internet and fetch artikel
      final online = await ArtikelService.hasInternet();
      final artikelList = await ArtikelService.getAllArtikel();
      final age = await ArtikelService.getCacheAge();

      if (!mounted) return;
      setState(() {
        allArtikel = artikelList;
        _updateFilteredArtikel('');
        isOffline = !online;
        cacheAge = age;
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

  Future<void> _forceRefresh() async {
    if (!mounted) return;

    final online = await ArtikelService.hasInternet();
    if (!online) {
      if (mounted) {
        setState(() => isOffline = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada koneksi internet'),
            backgroundColor: Color(0xFF00ADB5),
          ),
        );
      }
      return;
    }

    setState(() => isLoading = true);

    try {
      // Reload favorites with current user context
      final user = await AuthService.getStoredUser();
      final userId = user?.id.toString() ?? 'guest';
      _favoriteKey = 'favoriteArtikels_user_$userId';

      final prefs = await SharedPreferences.getInstance();
      await prefs.reload(); // Force reload from disk
      final favoriteIds = prefs.getStringList(_favoriteKey) ?? [];
      favoriteArtikels = favoriteIds.map((id) => int.tryParse(id) ?? 0).toSet();

      final artikelList = await ArtikelService.refreshArtikel();
      final age = await ArtikelService.getCacheAge();

      if (!mounted) return;
      setState(() {
        allArtikel = artikelList;
        _updateFilteredArtikel(searchController.text);
        isOffline = false;
        cacheAge = age;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Artikel berhasil diperbarui'),
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

  Future<void> _toggleFavorite(ArtikelModel artikel) async {
    // Check if user is logged in
    final user = await AuthService.getStoredUser();
    if (user == null) {
      // Show login dialog
      _showLoginRequiredDialog();
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteArtikels.contains(artikel.id)) {
        favoriteArtikels.remove(artikel.id);
      } else {
        favoriteArtikels.add(artikel.id);
      }
      // Save using user-specific key
      prefs.setStringList(
          _favoriteKey, favoriteArtikels.map((id) => id.toString()).toList());
      _updateFilteredArtikel(searchController.text);
    });
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Diperlukan'),
        content: const Text(
            'Silakan login terlebih dahulu untuk menyimpan artikel favorit.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _updateFilteredArtikel(String query) {
    List<ArtikelModel> filtered = allArtikel.where((artikel) {
      final matchJudul =
          artikel.judul.toLowerCase().contains(query.toLowerCase());
      final matchRingkasan =
          artikel.ringkasan.toLowerCase().contains(query.toLowerCase());
      return matchJudul || matchRingkasan;
    }).toList();

    // Sort: favorites first
    filtered.sort((a, b) {
      bool aFav = favoriteArtikels.contains(a.id);
      bool bFav = favoriteArtikels.contains(b.id);
      if (aFav && !bFav) return -1;
      if (!aFav && bFav) return 1;
      return b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0;
    });

    setState(() {
      filteredArtikel = filtered;
    });
  }

  void _filterArtikel(String query) {
    _updateFilteredArtikel(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Artikel'),
        automaticallyImplyLeading: false,
        actions: [
          if (isOffline)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.cloud_off,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Perbarui Artikel',
            onPressed: isLoading ? null : _forceRefresh,
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.edit_note),
              tooltip: 'Kelola Artikel',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ArtikelManagementPage()),
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
            Text('Memuat artikel...'),
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
              hintText: 'Cari artikel...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _filterArtikel,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filteredArtikel.length} artikel',
                style: const TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 73, 73, 73)),
              ),
              if (!isOffline && cacheAge != null)
                Text(
                  'Diperbarui: $cacheAge',
                  style: const TextStyle(
                      fontSize: 11, color: Color.fromARGB(255, 43, 43, 43)),
                ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _forceRefresh,
            child: ListView.builder(
              itemCount: filteredArtikel.length,
              itemBuilder: (context, index) {
                final artikel = filteredArtikel[index];
                final isFavorite = favoriteArtikels.contains(artikel.id);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      artikel.judul,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artikel.ringkasan,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00ADB5).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                artikel.kategori,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF00ADB5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              artikel.penulis,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () => _toggleFavorite(artikel),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArtikelDetailPage(artikel: artikel),
                        ),
                      );
                    },
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
