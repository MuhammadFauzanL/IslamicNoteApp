import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/artikel.dart';
import '../services/artikel_service.dart';

class ArtikelListPage extends StatefulWidget {
  const ArtikelListPage({super.key});

  @override
  State<ArtikelListPage> createState() => _ArtikelListPageState();
}

class _ArtikelListPageState extends State<ArtikelListPage> {
  final ArtikelService _service = ArtikelService();
  final TextEditingController _searchController = TextEditingController();

  List<Artikel> filtered = [];
  Set<String> favorites = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    favorites = prefs.getStringList('favorite_artikel')?.toSet() ?? {};
    filtered = _service.search('');
    setState(() => isLoading = false);
  }

  void _search(String q) {
    final result = _service.search(q);
    result.sort((a, b) {
      final af = favorites.contains(a.id);
      final bf = favorites.contains(b.id);
      if (af && !bf) return -1;
      if (!af && bf) return 1;
      return a.judul.compareTo(b.judul);
    });
    setState(() => filtered = result);
  }

  Future<void> _toggleFavorite(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
      prefs.setStringList('favorite_artikel', favorites.toList());
    });
    _search(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Artikel')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _search,
                    decoration: const InputDecoration(
                      hintText: 'Cari artikel...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final a = filtered[i];
                      final fav = favorites.contains(a.id);
                      return ListTile(
                        title: Text(a.judul),
                        trailing: IconButton(
                          icon: Icon(
                            fav ? Icons.favorite : Icons.favorite_border,
                            color: fav ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(a.id),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/artikel_detail',
                            arguments: a.id,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
