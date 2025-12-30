import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApi {
  static const String baseUrl =
      "https://web-production-40a77.up.railway.app/chat";

  static Future<Map<String, dynamic>> sendMessage(
    String query,
    String sessionId,
  ) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "query": query,
        "session_id": sessionId,
      }),
    );

    return jsonDecode(res.body);
  }
}
