import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoaListPage extends StatefulWidget {
  @override
  _DoaListPageState createState() => _DoaListPageState();
}

class _DoaListPageState extends State<DoaListPage> {
  final List<String> dummyDoa = [
    'Doa Turun Hujan',
    'Doa Masuk Rumah',
    'Doa Untuk Orang Tua',
  ];

  Set<String> favoriteDoas = Set<String>();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteDoas = prefs.getStringList('favoriteDoas')?.toSet() ?? Set<String>();
    });
  }

  _toggleFavorite(String doa) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteDoas.contains(doa)) {
        favoriteDoas.remove(doa);
      } else {
        favoriteDoas.add(doa);
      }
      prefs.setStringList('favoriteDoas', favoriteDoas.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Doa'),
      ),
      body: ListView.builder(
        itemCount: dummyDoa.length,
        itemBuilder: (context, index) {
          final doa = dummyDoa[index];
          final isFavorite = favoriteDoas.contains(doa);
          return ListTile(
            title: Text(doa),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                _toggleFavorite(doa);
              },
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/doa_detail',
                arguments: doa,
              );
            },
          );
        },
      ),
    );
  }
}
