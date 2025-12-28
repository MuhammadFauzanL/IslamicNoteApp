import 'package:flutter/foundation.dart';

class ApiConfig {
  static const Duration timeout = Duration(seconds: 15);

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:4000/api';
    }
    return 'http://10.0.2.2:4000/api';
  }

  // ⬇️ TAMBAHKAN INI KEMBALI (WAJIB UNTUK ADMIN)
  static String get authUrl => '$baseUrl/auth';
  static String get artikelUrl => '$baseUrl/artikel';
  static String get doaUrl => '$baseUrl/doa';
}
