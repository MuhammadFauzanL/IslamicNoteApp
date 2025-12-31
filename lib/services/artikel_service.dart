import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/artikel_model.dart';
import '../config/api_config.dart';

class ArtikelService {
  // ================================
  // 🌐 CHECK INTERNET (BACKEND HEALTH)
  // ================================
  static Future<bool> hasInternet() async {
    try {
      final res = await http
          .get(Uri.parse(ApiConfig.healthUrl))
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // =========================================
  // 📚 GET ALL ARTIKEL (OFFLINE-FIRST)
  // =========================================
  static Future<List<ArtikelModel>> getAllArtikel() async {
    try {
      print('🔍 ArtikelService: Starting getAllArtikel...');

      final online = await hasInternet();
      print('🌐 Internet status: ${online ? "ONLINE" : "OFFLINE"}');

      // =====================
      // ONLINE → FETCH API
      // =====================
      if (online) {
        try {
          print('📡 Fetching artikel from API...');
          final response = await http
              .get(Uri.parse(ApiConfig.artikelUrl))
              .timeout(const Duration(seconds: 15));

          print('📥 Status: ${response.statusCode}');

          if (response.statusCode == 200) {
            final decoded = json.decode(response.body);

            if (decoded is Map &&
                decoded['success'] == true &&
                decoded['data'] is List) {
              final List<dynamic> jsonData = decoded['data'];

              // Save to cache
              await _saveArtikelToCache(json.encode(jsonData));

              print('✅ API fetch successful, ${jsonData.length} artikel');
              return jsonData.map((e) => ArtikelModel.fromJson(e)).toList();
            } else {
              throw Exception('Format data artikel salah');
            }
          }
        } catch (e) {
          print('⚠️ API fetch failed: $e');
          // Continue to cache
        }
      }

      // =====================
      // OFFLINE → CACHE
      // =====================
      print('💾 Trying cache...');
      final cachedArtikel = await _loadArtikelFromCache();
      if (cachedArtikel.isNotEmpty) {
        print('✅ Loaded ${cachedArtikel.length} artikel from cache');
        return cachedArtikel;
      }

      // No cache available
      print('❌ No cached artikel available');
      return [];
    } catch (e) {
      print('❌ Error in getAllArtikel: $e');
      // Try cache as fallback
      return await _loadArtikelFromCache();
    }
  }

  // =====================
  // 💾 SAVE CACHE
  // =====================
  static Future<void> _saveArtikelToCache(String jsonData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_artikel_data', jsonData);
      await prefs.setString(
        'cached_artikel_timestamp',
        DateTime.now().toIso8601String(),
      );
      print('✅ Artikel saved to cache');
    } catch (e) {
      print('❌ Error saving artikel to cache: $e');
    }
  }

  // =====================
  // 📂 LOAD CACHE
  // =====================
  static Future<List<ArtikelModel>> _loadArtikelFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_artikel_data');

      if (cachedData != null) {
        final List<dynamic> jsonData = json.decode(cachedData);
        return jsonData.map((e) => ArtikelModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('❌ Error loading artikel from cache: $e');
    }
    return [];
  }

  // =====================
  // 🔄 FORCE REFRESH (MANUAL)
  // =====================
  static Future<List<ArtikelModel>> refreshArtikel() async {
    try {
      print('🔄 Force refreshing artikel...');
      final response = await http
          .get(Uri.parse(ApiConfig.artikelUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map &&
            decoded['success'] == true &&
            decoded['data'] is List) {
          final List<dynamic> jsonData = decoded['data'];

          await _saveArtikelToCache(json.encode(jsonData));

          return jsonData.map((e) => ArtikelModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('❌ Refresh failed: $e');
    }

    // Don't clear cache if failed
    return await _loadArtikelFromCache();
  }

  // =====================
  // 📅 CACHE AGE
  // =====================
  static Future<String?> getCacheAge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getString('cached_artikel_timestamp');

      if (timestamp != null) {
        final cacheDate = DateTime.parse(timestamp);
        final diff = DateTime.now().difference(cacheDate);

        if (diff.inDays > 0) return '${diff.inDays} hari yang lalu';
        if (diff.inHours > 0) return '${diff.inHours} jam yang lalu';
        if (diff.inMinutes > 0) return '${diff.inMinutes} menit yang lalu';
        return 'Baru saja';
      }
    } catch (e) {
      print('❌ Error getting cache age: $e');
    }
    return null;
  }
}
