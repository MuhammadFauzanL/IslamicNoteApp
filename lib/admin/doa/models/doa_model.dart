class Doa {
  final int id;
  final String judul;
  final String arab;
  final String latin;
  final String arti;

  Doa({
    required this.id,
    required this.judul,
    required this.arab,
    required this.latin,
    required this.arti,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: json['id'],
      judul: json['judul'],
      arab: json['arab'],
      latin: json['latin'],
      arti: json['arti'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'arab': arab,
      'latin': latin,
      'arti': arti,
    };
  }
}
