import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtikelListPage extends StatefulWidget {
  @override
  _ArtikelListPageState createState() => _ArtikelListPageState();
}

class _ArtikelListPageState extends State<ArtikelListPage> {
  final List<String> originalArtikel = [
    'Manfaat Sedekah',
    'Cara Wudhu yang Benar',
    'Keutamaan Sholat Dhuha',
  ];

  List<String> filteredArtikel = [];
  Set<String> favoriteArtikels = Set<String>();
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteArtikels = prefs.getStringList('favoriteArtikels')?.toSet() ?? Set<String>();
      _updateFilteredArtikel('');
      isLoading = false;
    });
  }

  _toggleFavorite(String artikel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteArtikels.contains(artikel)) {
        favoriteArtikels.remove(artikel);
      } else {
        favoriteArtikels.add(artikel);
      }
      prefs.setStringList('favoriteArtikels', favoriteArtikels.toList());
      _updateFilteredArtikel(searchController.text);
    });
  }

  void _updateFilteredArtikel(String query) {
    List<String> filtered = originalArtikel.where((artikel) {
      return artikel.toLowerCase().contains(query.toLowerCase());
    }).toList();

    filtered.sort((a, b) {
      bool aFav = favoriteArtikels.contains(a);
      bool bFav = favoriteArtikels.contains(b);
      if (aFav && !bFav) return -1;
      if (!aFav && bFav) return 1;
      return a.compareTo(b);
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredArtikel.length,
                    itemBuilder: (context, index) {
                      final artikel = filteredArtikel[index];
                      final isFavorite = favoriteArtikels.contains(artikel);
                      return ListTile(
                        title: Text(artikel),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(artikel),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/artikel_detail', arguments: artikel);
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
