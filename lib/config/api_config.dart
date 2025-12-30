import 'package:flutter/foundation.dart';

class ApiConfig {
  static const Duration timeout = Duration(seconds: 15);

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:4000';
    }
    return 'http://10.0.2.2:4000';
  }

  static String get authUrl => '$baseUrl/api/auth';
  static String get artikelUrl => '$baseUrl/api/artikel';
  static String get doaUrl => '$baseUrl/api/doa';
  static String get healthUrl => '$baseUrl/api/health';
}
