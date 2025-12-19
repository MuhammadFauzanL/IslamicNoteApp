import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_user.dart';

class AuthService {
  final String baseUrl = 'https://your-api-url.com/api';

  // Login
  Future<AuthUser?> login({
    required String email,
    required String password,
    required String role, // 'user' atau 'admin'
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'email': email, 'password': password, 'role': role}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthUser.fromJson(data['user']);
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }

  // Register
  Future<AuthUser?> register({
    required String name,
    required String email,
    required String password,
    required String role, // 'user' atau 'admin'
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return AuthUser.fromJson(data['user']);
    } else {
      throw Exception('Register gagal: ${response.body}');
    }
  }
}
