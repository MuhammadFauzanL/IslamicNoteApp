import '../models/artikel_model.dart';

class ArtikelAdminService {
  static final List<Artikel> _artikelList = [
    Artikel(
      id: 1,
      judul: 'Artikel Admin 1',
      konten: 'Konten artikel admin',
      tanggal: '2025-01-01',
    ),
  ];

  /// GET ALL
  static Future<List<Artikel>> getAllArtikel() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _artikelList;
  }

  /// CREATE
  static Future<void> createArtikel({
    required String judul,
    required String konten,
  }) async {
    final newArtikel = Artikel(
      id: DateTime.now().millisecondsSinceEpoch,
      judul: judul,
      konten: konten,
      tanggal: DateTime.now().toIso8601String(),
    );

    _artikelList.add(newArtikel);
  }

  /// UPDATE
  static Future<void> updateArtikel({
    required int id,
    required String judul,
    required String konten,
  }) async {
    final index = _artikelList.indexWhere((a) => a.id == id);
    if (index != -1) {
      _artikelList[index] = Artikel(
        id: id,
        judul: judul,
        konten: konten,
        tanggal: _artikelList[index].tanggal,
      );
    }
  }

  /// DELETE
  static Future<void> deleteArtikel(int id) async {
    _artikelList.removeWhere((a) => a.id == id);
  }
}
