class Artikel {
  final int id;
  final String judul;
  final String konten;
  final String tanggal;

  Artikel({
    required this.id,
    required this.judul,
    required this.konten,
    required this.tanggal,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      id: json['id'],
      judul: json['judul'],
      konten: json['konten'],
      tanggal: json['tanggal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'judul': judul, 'konten': konten, 'tanggal': tanggal};
  }
}
