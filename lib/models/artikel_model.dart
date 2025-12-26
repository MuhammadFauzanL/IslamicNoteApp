class ArtikelModel {
  final int id;
  final String judul;
  final String ringkasan;
  final String konten;
  final String? gambarUrl;
  final String kategori;
  final String penulis;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ArtikelModel({
    required this.id,
    required this.judul,
    required this.ringkasan,
    required this.konten,
    this.gambarUrl,
    required this.kategori,
    required this.penulis,
    this.createdAt,
    this.updatedAt,
  });

  factory ArtikelModel.fromJson(Map<String, dynamic> json) {
    return ArtikelModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      ringkasan: json['ringkasan'] ?? '',
      konten: json['konten'] ?? '',
      gambarUrl: json['gambar_url'],
      kategori: json['kategori'] ?? 'Umum',
      penulis: json['penulis'] ?? 'Admin',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'ringkasan': ringkasan,
      'konten': konten,
      'gambar_url': gambarUrl,
      'kategori': kategori,
      'penulis': penulis,
    };
  }
}
