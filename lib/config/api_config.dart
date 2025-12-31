import 'package:flutter/foundation.dart';

class ApiConfig {
  static const Duration timeout = Duration(seconds: 15);

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    // -------------------------------------------------------------------------
    // 🔴 PENTING: Pilih salah satu URL di bawah ini sesuai device Anda!
    // -------------------------------------------------------------------------

    // 1️⃣ Untuk EMULATOR Android (Gunakan ini jika testing di Laptop)
    // return 'http://10.0.2.2:3000';

    // 2️⃣ Untuk HP FISIK (Gunakan IP Laptop, pastikan Firewall Allow Node.js)
    return 'http://192.168.1.12:3000';
  }

  static String get authUrl => '$baseUrl/api/auth';
  static String get artikelUrl => '$baseUrl/api/artikel';
  static String get doaUrl => '$baseUrl/api/doa';
  static String get healthUrl => '$baseUrl/api/health';
}
