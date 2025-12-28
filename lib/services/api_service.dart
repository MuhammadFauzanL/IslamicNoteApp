import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doa_model.dart';
import '../models/artikel_model.dart';
import '../config/api_config.dart';
import 'cache_service.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;
  static Duration get timeout => ApiConfig.timeout;

  // ==================== DOA ====================

  static Future<List<DoaModel>> getAllDoa() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/doa'))
          .timeout(timeout);

      if (res.statusCode != 200) {
        throw Exception('Server error ${res.statusCode}');
      }

      final body = json.decode(res.body);
      final List list = body['data'];

      final result = list.map((e) => DoaModel.fromJson(e)).toList();
      await CacheService.cacheDoa(result);
      return result;
    } catch (_) {
      final cached = await CacheService.getCachedDoa();
      if (cached != null) return cached;
      rethrow;
    }
  }

  static Future<DoaModel> getDoaById(int id) async {
    final res = await http
        .get(Uri.parse('$baseUrl/doa/$id'))
        .timeout(timeout);

    final body = json.decode(res.body);
    return DoaModel.fromJson(body['data']);
  }

  // ==================== ARTIKEL ====================

  static Future<List<ArtikelModel>> getAllArtikel() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/artikel'))
          .timeout(timeout);

      if (res.statusCode != 200) {
        throw Exception('Server error ${res.statusCode}');
      }

      final body = json.decode(res.body);
      final List list = body['data'];

      final result = list.map((e) => ArtikelModel.fromJson(e)).toList();
      await CacheService.cacheArtikel(result);
      return result;
    } catch (_) {
      final cached = await CacheService.getCachedArtikel();
      if (cached != null) return cached;
      rethrow;
    }
  }

  static Future<ArtikelModel> getArtikelById(int id) async {
    final res = await http
        .get(Uri.parse('$baseUrl/artikel/$id'))
        .timeout(timeout);

    final body = json.decode(res.body);
    return ArtikelModel.fromJson(body['data']);
  }
}
