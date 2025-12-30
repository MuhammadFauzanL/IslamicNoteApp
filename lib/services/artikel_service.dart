import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artikel_model.dart';
import '../config/api_config.dart';

class ArtikelService {
  static Future<List<ArtikelModel>> getAllArtikel() async {
    try {
      print('📡 Fetch artikel...');
      print('➡️ URL: ${ApiConfig.artikelUrl}');

      final response = await http
          .get(Uri.parse(ApiConfig.artikelUrl))
          .timeout(const Duration(seconds: 15));

      print('📥 Status: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map &&
            decoded['success'] == true &&
            decoded['data'] is List) {
          final List<dynamic> list = decoded['data'];
          return list.map((e) => ArtikelModel.fromJson(e)).toList();
        } else {
          throw Exception('Format data artikel salah');
        }
      } else {
        throw Exception('Server error ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ArtikelService error: $e');
      rethrow;
    }
  }
}
