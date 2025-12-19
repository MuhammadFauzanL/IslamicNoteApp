class UserModel {
  final int id;
  final String name;
  final String email;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'is_active': isActive};
  }

  UserModel copyWith({int? id, String? name, String? email, bool? isActive}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
    );
  }
}
