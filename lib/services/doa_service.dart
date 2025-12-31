import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doa_model.dart';
import '../config/api_config.dart';

class DoaService {
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
  // 📚 GET ALL DOA (OFFLINE-FIRST, AUTO UPDATE)
  // =========================================
  static Future<List<DoaModel>> getAllDoa() async {
    try {
      print('🔍 DoaService: Starting getAllDoa...');

      final online = await hasInternet();
      print('🌐 Internet status: ${online ? "ONLINE" : "OFFLINE"}');

      // =====================
      // ONLINE → FETCH API
      // =====================
      if (online) {
        try {
          print('📡 Fetching from API...');
          final response = await http
              .get(Uri.parse(ApiConfig.doaUrl))
              .timeout(const Duration(seconds: 10));

          if (response.statusCode == 200) {
            print('✅ API fetch successful');

            final decoded = json.decode(response.body);

            // 🔴 FIX UTAMA: API MENGEMBALIKAN MAP, BUKAN LIST
            if (decoded is Map && decoded['data'] is List) {
              final List<dynamic> jsonData = decoded['data'];

              // simpan cache hanya DATA-nya
              await _saveDoaToCache(json.encode(jsonData));

              return jsonData.map((e) => DoaModel.fromJson(e)).toList();
            } else {
              throw Exception('Format response doa tidak valid');
            }
          }
        } catch (e) {
          print('⚠️ API fetch failed: $e');
          // lanjut ke cache
        }
      }

      // =====================
      // OFFLINE → CACHE
      // =====================
      print('💾 Trying cache...');
      final cachedDoa = await _loadDoaFromCache();
      if (cachedDoa.isNotEmpty) {
        print('✅ Loaded ${cachedDoa.length} doa from cache');
        return cachedDoa;
      }

      // =====================
      // LAST RESORT → ASSETS
      // =====================
      print('📦 Loading from bundled assets...');
      return await _loadDoaFromAssets();
    } catch (e) {
      print('❌ Error in getAllDoa: $e');
      return await _loadDoaFromAssets();
    }
  }

  // =====================
  // 💾 SAVE CACHE
  // =====================
  static Future<void> _saveDoaToCache(String jsonData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_doa_data', jsonData);
      await prefs.setString(
        'cached_doa_timestamp',
        DateTime.now().toIso8601String(),
      );
      print('✅ Doa saved to cache');
    } catch (e) {
      print('❌ Error saving doa to cache: $e');
    }
  }

  // =====================
  // 📂 LOAD CACHE
  // =====================
  static Future<List<DoaModel>> _loadDoaFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_doa_data');

      if (cachedData != null) {
        final List<dynamic> jsonData = json.decode(cachedData);
        return jsonData.map((e) => DoaModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('❌ Error loading doa from cache: $e');
    }
    return [];
  }

  // =====================
  // 📦 LOAD ASSETS (FALLBACK)
  // =====================
  static Future<List<DoaModel>> _loadDoaFromAssets() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/doa_dataset.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((e) => DoaModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error loading doa from assets: $e');
      return [];
    }
  }

  // =====================
  // 🔄 FORCE REFRESH (MANUAL)
  // =====================
  static Future<List<DoaModel>> refreshDoa() async {
    try {
      print('🔄 Force refreshing doa...');
      final response = await http
          .get(Uri.parse(ApiConfig.doaUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map && decoded['data'] is List) {
          final List<dynamic> jsonData = decoded['data'];

          await _saveDoaToCache(json.encode(jsonData));

          return jsonData.map((e) => DoaModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('❌ Refresh failed: $e');
    }

    // ❌ JANGAN HAPUS CACHE JIKA GAGAL
    return await _loadDoaFromCache();
  }

  // =====================
  // 📅 CACHE AGE
  // =====================
  static Future<String?> getCacheAge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getString('cached_doa_timestamp');

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
