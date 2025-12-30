class DoaModel {
  final String id;
  final String label;
  final String judul;
  final String arab;
  final String latin;
  final String arti;
  final List<String> keywords;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DoaModel({
    required this.id,
    required this.label,
    required this.judul,
    required this.arab,
    required this.latin,
    required this.arti,
    required this.keywords,
    this.createdAt,
    this.updatedAt,
  });

  factory DoaModel.fromJson(Map<String, dynamic> json) {
    return DoaModel(
      // 🔥 FIX UTAMA DI SINI
      id: json['id']?.toString() ?? '',

      label: json['label']?.toString() ?? '',
      judul: json['judul']?.toString() ?? '',
      arab: json['arab']?.toString() ?? '',
      latin: json['latin']?.toString() ?? '',
      arti: json['arti']?.toString() ?? '',

      keywords: json['keywords'] is List
          ? List<String>.from(
              json['keywords'].map((e) => e.toString()),
            )
          : [],

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'judul': judul,
      'arab': arab,
      'latin': latin,
      'arti': arti,
      'keywords': keywords,
    };
  }
}
