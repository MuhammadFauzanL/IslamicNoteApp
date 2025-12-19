import '../data/artikel_dummy.dart';
import '../models/artikel.dart';

class ArtikelService {
  List<Artikel> search(String query) {
    final q = query.toLowerCase();
    return artikelList.where((a) {
      return a.judul.toLowerCase().contains(q) ||
          a.tags.any((t) => t.contains(q));
    }).toList();
  }

  Artikel? getById(String id) {
    for (final artikel in artikelList) {
      if (artikel.id == id) {
        return artikel;
      }
    }
    return null;
  }
}
