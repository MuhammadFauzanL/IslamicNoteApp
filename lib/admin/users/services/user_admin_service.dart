import 'dart:async';
import '../models/user_model.dart';

class UserAdminService {
  /// Simulasi database user
  static final List<UserModel> _dummyUsers = [
    UserModel(
      id: 1,
      name: 'Ahmad Fauzi',
      email: 'ahmad@gmail.com',
      isActive: true,
    ),
    UserModel(
      id: 2,
      name: 'Siti Aminah',
      email: 'siti@gmail.com',
      isActive: true,
    ),
    UserModel(
      id: 3,
      name: 'Budi Santoso',
      email: 'budi@gmail.com',
      isActive: false,
    ),
  ];

  /// GET users
  static Future<List<UserModel>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List<UserModel>.from(_dummyUsers);
  }

  /// UPDATE status user
  static Future<void> updateUserStatus({
    required int userId,
    required bool isActive,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _dummyUsers.indexWhere((user) => user.id == userId);

    if (index != -1) {
      _dummyUsers[index] = _dummyUsers[index].copyWith(isActive: isActive);
    }
  }

  /// DELETE user (opsional)
  static Future<void> deleteUser(int userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _dummyUsers.removeWhere((user) => user.id == userId);
  }
}
