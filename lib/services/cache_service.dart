import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doa_model.dart';
import '../models/artikel_model.dart';

/// Service untuk menyimpan data offline menggunakan SharedPreferences
class CacheService {
  static const String _doaListKey = 'cached_doa_list';
  static const String _artikelListKey = 'cached_artikel_list';

  // Cache duration: 24 hours
  static const Duration cacheExpiry = Duration(hours: 24);

  // ==================== DOA CACHE ====================

  /// Save doa list to cache
  static Future<void> cacheDoa(List<DoaModel> doaList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = doaList.map((d) => d.toJson()).toList();
    await prefs.setString(_doaListKey, json.encode(jsonList));
    await prefs.setInt(
        '${_doaListKey}_time', DateTime.now().millisecondsSinceEpoch);
  }

  /// Get doa list from cache
  static Future<List<DoaModel>?> getCachedDoa() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_doaListKey);

      if (jsonString == null) return null;

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => DoaModel.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  /// Check if doa cache is still valid
  static Future<bool> isDoaCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheTime = prefs.getInt('${_doaListKey}_time');

    if (cacheTime == null) return false;

    final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
    return DateTime.now().difference(cacheDate) < cacheExpiry;
  }

  // ==================== ARTIKEL CACHE ====================

  /// Save artikel list to cache
  static Future<void> cacheArtikel(List<ArtikelModel> artikelList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = artikelList.map((a) => a.toJson()).toList();
    await prefs.setString(_artikelListKey, json.encode(jsonList));
    await prefs.setInt(
        '${_artikelListKey}_time', DateTime.now().millisecondsSinceEpoch);
  }

  /// Get artikel list from cache
  static Future<List<ArtikelModel>?> getCachedArtikel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_artikelListKey);

      if (jsonString == null) return null;

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ArtikelModel.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  /// Check if artikel cache is still valid
  static Future<bool> isArtikelCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheTime = prefs.getInt('${_artikelListKey}_time');

    if (cacheTime == null) return false;

    final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
    return DateTime.now().difference(cacheDate) < cacheExpiry;
  }

  // ==================== UTILITIES ====================

  /// Clear all cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_doaListKey);
    await prefs.remove('${_doaListKey}_time');
    await prefs.remove(_artikelListKey);
    await prefs.remove('${_artikelListKey}_time');
  }
}
