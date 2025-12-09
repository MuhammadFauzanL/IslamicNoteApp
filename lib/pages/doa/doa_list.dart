import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doa_data.dart'; // import file doa_data.dart

class DoaListPage extends StatefulWidget {
  @override
  _DoaListPageState createState() => _DoaListPageState();
}

class _DoaListPageState extends State<DoaListPage> {
  late List<String> originalDoa;
  List<String> filteredDoa = [];
  Set<String> favoriteDoas = Set<String>();
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    originalDoa = doaList.map((d) => d.judul).toList();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // simulasi delay

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteDoas = prefs.getStringList('favoriteDoas')?.toSet() ?? Set<String>();
      _updateFilteredDoa('');
      isLoading = false;
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
      _updateFilteredDoa(searchController.text);
    });
  }

  void _updateFilteredDoa(String query) {
    List<String> filtered = originalDoa.where((doa) {
      return doa.toLowerCase().contains(query.toLowerCase());
    }).toList();

    filtered.sort((a, b) {
      bool aFav = favoriteDoas.contains(a);
      bool bFav = favoriteDoas.contains(b);
      if (aFav && !bFav) return -1;
      if (!aFav && bFav) return 1;
      return a.compareTo(b);
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
      appBar: AppBar(title: const Text('Daftar Doa')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                  child: ListView.builder(
                    itemCount: filteredDoa.length,
                    itemBuilder: (context, index) {
                      final doaJudul = filteredDoa[index];
                      final isFavorite = favoriteDoas.contains(doaJudul);
                      return ListTile(
                        title: Text(doaJudul),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(doaJudul),
                        ),
                        onTap: () {
                          final doaObj = doaList.firstWhere((d) => d.judul == doaJudul);
                          Navigator.pushNamed(context, '/doa_detail', arguments: doaObj);
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
