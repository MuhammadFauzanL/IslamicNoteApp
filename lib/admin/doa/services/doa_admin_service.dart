import '../models/doa_model.dart';

class DoaAdminService {
  static final List<Doa> _doaList = [
    Doa(
      id: 1,
      judul: 'Doa Sebelum Belajar',
      arab: 'رَبِّ زِدْنِي عِلْمًا',
      latin: 'Rabbi zidnii ilma',
      arti: 'Ya Allah, tambahkanlah aku ilmu',
    ),
  ];

  /// GET ALL
  static Future<List<Doa>> getAllDoa() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _doaList;
  }

  /// CREATE
  static Future<void> createDoa({
    required String judul,
    required String arab,
    required String latin,
    required String arti,
  }) async {
    final newDoa = Doa(
      id: DateTime.now().millisecondsSinceEpoch,
      judul: judul,
      arab: arab,
      latin: latin,
      arti: arti,
    );

    _doaList.add(newDoa);
  }

  /// UPDATE
  static Future<void> updateDoa({
    required int id,
    required String judul,
    required String arab,
    required String latin,
    required String arti,
  }) async {
    final index = _doaList.indexWhere((d) => d.id == id);
    if (index != -1) {
      _doaList[index] = Doa(
        id: id,
        judul: judul,
        arab: arab,
        latin: latin,
        arti: arti,
      );
    }
  }

  /// DELETE
  static Future<void> deleteDoa(int id) async {
    _doaList.removeWhere((d) => d.id == id);
  }
}
