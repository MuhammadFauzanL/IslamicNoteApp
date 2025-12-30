import '../models/doa_model.dart';
import '../models/artikel_model.dart';
import '../config/api_config.dart';
import 'doa_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // =========================
  // DOA (OFFLINE-FIRST)
  // =========================

  /// 🔹 Ambil semua doa
  /// - Offline → cache / assets
  /// - Online → API + update cache
  static Future<List<DoaModel>> getAllDoa() async {
    return await DoaService.getAllDoa();
  }

  /// 🔹 Ambil doa by ID (dari cache / assets)
  static Future<DoaModel?> getDoaById(int id) async {
    final list = await DoaService.getAllDoa();
    try {
      return list.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  // =========================
  // ARTIKEL (ONLINE ONLY)
  // =========================

  /// 🔹 Ambil semua artikel
  /// ❗ WAJIB internet
  static Future<List<ArtikelModel>> getAllArtikel() async {
    final online = await _hasInternet();
    if (!online) {
      throw Exception('Artikel memerlukan koneksi internet');
    }

    final response = await http
        .get(Uri.parse(ApiConfig.artikelUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat artikel');
    }

    final body = json.decode(response.body);

    // SESUAIKAN jika backend kamu pakai { data: [...] }
    final List list = body is Map ? body['data'] : body;

    return list.map((e) => ArtikelModel.fromJson(e)).toList();
  }

  /// 🔹 Ambil artikel by ID
  static Future<ArtikelModel> getArtikelById(int id) async {
    final online = await _hasInternet();
    if (!online) {
      throw Exception('Artikel memerlukan koneksi internet');
    }

    final response = await http
        .get(Uri.parse('${ApiConfig.artikelUrl}/$id'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat artikel');
    }

    final body = json.decode(response.body);
    final data = body is Map ? body['data'] : body;

    return ArtikelModel.fromJson(data);
  }

  // =========================
  // INTERNET CHECK
  // =========================

  static Future<bool> _hasInternet() async {
    try {
      final res = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
