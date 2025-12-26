class DoaModel {
  final int id;
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
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      judul: json['judul'] ?? '',
      arab: json['arab'] ?? '',
      latin: json['latin'] ?? '',
      arti: json['arti'] ?? '',
      keywords:
          json['keywords'] != null ? List<String>.from(json['keywords']) : [],
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
      'label': label,
      'judul': judul,
      'arab': arab,
      'latin': latin,
      'arti': arti,
      'keywords': keywords,
    };
  }
}
