import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtikelListPage extends StatefulWidget {
  @override
  _ArtikelListPageState createState() => _ArtikelListPageState();
}

class _ArtikelListPageState extends State<ArtikelListPage> {
  final List<String> dummyArtikel = [
    'Manfaat Sedekah',
    'Cara Wudhu yang Benar',
    'Keutamaan Sholat Dhuha',
  ];

  Set<String> favoriteArtikels = Set<String>();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteArtikels = prefs.getStringList('favoriteArtikels')?.toSet() ?? Set<String>();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Artikel'),
      ),
      body: ListView.builder(
        itemCount: dummyArtikel.length,
        itemBuilder: (context, index) {
          final artikel = dummyArtikel[index];
          final isFavorite = favoriteArtikels.contains(artikel);
          return ListTile(
            title: Text(artikel),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                _toggleFavorite(artikel);
              },
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/artikel_detail',
                arguments: artikel,
              );
            },
          );
        },
      ),
    );
  }
}
