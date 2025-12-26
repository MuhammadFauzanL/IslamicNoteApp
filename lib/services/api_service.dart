import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doa_model.dart';
import '../models/artikel_model.dart';
import '../config/api_config.dart';
import 'cache_service.dart';

class ApiService {
  // Menggunakan config terpusat
  static String get baseUrl => ApiConfig.baseUrl;
  static Duration get timeout => ApiConfig.timeout;

  // ==================== DOA API ====================

  // GET all doa (with caching for offline mode)
  static Future<List<DoaModel>> getAllDoa() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/doa')).timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> doaList = data['data'];
          final result =
              doaList.map((json) => DoaModel.fromJson(json)).toList();

          // Cache data for offline use
          await CacheService.cacheDoa(result);

          return result;
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load doa: ${response.statusCode}');
      }
    } catch (e) {
      // Try to get cached data when offline
      final cachedDoa = await CacheService.getCachedDoa();
      if (cachedDoa != null && cachedDoa.isNotEmpty) {
        return cachedDoa;
      }
      throw Exception('Tidak dapat terhubung. Periksa koneksi internet Anda.');
    }
  }

  // GET doa by ID
  static Future<DoaModel> getDoaById(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/doa/$id')).timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return DoaModel.fromJson(data['data']);
        } else {
          throw Exception('Doa tidak ditemukan');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Doa tidak ditemukan');
      } else {
        throw Exception('Failed to load doa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching doa: $e');
    }
  }

  // Search doa
  static Future<List<DoaModel>> searchDoa(String keyword) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/doa?search=$keyword'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> doaList = data['data'];
          return doaList.map((json) => DoaModel.fromJson(json)).toList();
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to search doa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching doa: $e');
    }
  }

  // ==================== ARTIKEL API ====================

  // GET all artikel (with caching for offline mode)
  static Future<List<ArtikelModel>> getAllArtikel() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/artikel')).timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> artikelList = data['data'];
          final result =
              artikelList.map((json) => ArtikelModel.fromJson(json)).toList();

          // Cache data for offline use
          await CacheService.cacheArtikel(result);

          return result;
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load artikel: ${response.statusCode}');
      }
    } catch (e) {
      // Try to get cached data when offline
      final cachedArtikel = await CacheService.getCachedArtikel();
      if (cachedArtikel != null && cachedArtikel.isNotEmpty) {
        return cachedArtikel;
      }
      throw Exception('Tidak dapat terhubung. Periksa koneksi internet Anda.');
    }
  }

  // GET artikel by ID
  static Future<ArtikelModel> getArtikelById(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/artikel/$id')).timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return ArtikelModel.fromJson(data['data']);
        } else {
          throw Exception('Artikel tidak ditemukan');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Artikel tidak ditemukan');
      } else {
        throw Exception('Failed to load artikel: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching artikel: $e');
    }
  }

  // Search artikel
  static Future<List<ArtikelModel>> searchArtikel(String keyword) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/artikel?search=$keyword'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> artikelList = data['data'];
          return artikelList
              .map((json) => ArtikelModel.fromJson(json))
              .toList();
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to search artikel: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching artikel: $e');
    }
  }
}
