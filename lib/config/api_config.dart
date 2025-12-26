/// API Configuration
///
/// Ganti URL di sini sesuai environment:
/// - Emulator Android: 'http://10.0.2.2:3000/api'
/// - HP Lokal (WiFi sama): 'http://[IP_KOMPUTER]:3000/api'
/// - Production (Railway): 'https://[YOUR_RAILWAY_URL]/api'

class ApiConfig {
  // ========== GANTI URL DI SINI ==========
  // static const String baseUrl = 'http://192.168.1.4:3000/api'; // rid
  static const String baseUrl = 'http://10.0.2.2:3000/api';


  // ========================================

  // Auth endpoint
  static const String authUrl = '$baseUrl/auth';

  // Doa endpoints
  static const String doaUrl = '$baseUrl/doa';

  // Artikel endpoints
  static const String artikelUrl = '$baseUrl/artikel';

  // Timeout untuk request
  static const Duration timeout = Duration(seconds: 15);
}
