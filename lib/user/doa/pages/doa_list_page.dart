import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/doa_dummy.dart';
import '../models/doa.dart';

class DoaListPage extends StatefulWidget {
  const DoaListPage({super.key});

  @override
  State<DoaListPage> createState() => _DoaListPageState();
}

class _DoaListPageState extends State<DoaListPage> {
  final TextEditingController searchController = TextEditingController();
  List<Doa> filteredDoa = [];
  Set<String> favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    filteredDoa = doaList;
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteIds = prefs.getStringList('favoriteDoas')?.toSet() ?? {};
    });
  }

  Future<void> _toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteIds.contains(id) ? favoriteIds.remove(id) : favoriteIds.add(id);
      prefs.setStringList('favoriteDoas', favoriteIds.toList());
    });
  }

  void _filter(String query) {
    setState(() {
      filteredDoa = doaList.where((doa) {
        return doa.judul.toLowerCase().contains(query.toLowerCase()) ||
            doa.keywords.any(
              (k) => k.toLowerCase().contains(query.toLowerCase()),
            );
      }).toList();

      filteredDoa.sort((a, b) {
        final aFav = favoriteIds.contains(a.id);
        final bFav = favoriteIds.contains(b.id);
        if (aFav && !bFav) return -1;
        if (!aFav && bFav) return 1;
        return a.judul.compareTo(b.judul);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Doa')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Cari doa...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filter,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoa.length,
              itemBuilder: (_, index) {
                final doa = filteredDoa[index];
                final isFav = favoriteIds.contains(doa.id);

                return ListTile(
                  title: Text(doa.judul),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(doa.id),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/doa_detail',
                      arguments: doa.id,
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
