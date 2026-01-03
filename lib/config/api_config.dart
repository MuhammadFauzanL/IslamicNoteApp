import 'package:flutter/foundation.dart';

class ApiConfig {
  static const Duration timeout = Duration(seconds: 15);

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    // Production URL (Railway)
    return 'https://islamicnoteapp-production.up.railway.app';
  }

  static String get authUrl => '$baseUrl/api/auth';
  static String get artikelUrl => '$baseUrl/api/artikel';
  static String get doaUrl => '$baseUrl/api/doa';
  static String get healthUrl => '$baseUrl/api/health';
}
