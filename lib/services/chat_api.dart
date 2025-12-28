import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApi {
  static const String baseUrl =
      "http://127.0.0.1:5005/chat"; // GANTI INI

  static Future<Map<String, dynamic>> sendMessage(
      String text, String sessionId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "query": text,
        "session_id": sessionId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Server error");
    }

    return jsonDecode(response.body);
  }
}
