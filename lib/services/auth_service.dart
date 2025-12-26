import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../config/api_config.dart';

class AuthService {
  // Menggunakan config terpusat
  static String get baseUrl => ApiConfig.authUrl;
  static Duration get timeout => ApiConfig.timeout;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  // ======================== TOKEN MANAGEMENT ========================

  // Save token and user to storage
  static Future<void> saveAuthData(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get stored user
  static Future<UserModel?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  // Clear auth data (logout)
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Check if current user is admin
  static Future<bool> isAdmin() async {
    final user = await getStoredUser();
    return user?.isAdmin ?? false;
  }

  // ======================== API CALLS ========================

  // Register new user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeout);

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        final user = UserModel.fromJson(data['data']['user']);
        final token = data['data']['token'];
        await saveAuthData(token, user);
        return {'success': true, 'user': user};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeout);

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final user = UserModel.fromJson(data['data']['user']);
        final token = data['data']['token'];
        await saveAuthData(token, user);
        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Logout
  static Future<void> logout() async {
    await clearAuthData();
  }

  // Get current user from API
  static Future<UserModel?> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeout);

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return UserModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get auth headers for protected API calls
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Change password
  static Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .put(
            Uri.parse('$baseUrl/change-password'),
            headers: headers,
            body: json.encode({
              'oldPassword': oldPassword,
              'newPassword': newPassword,
            }),
          )
          .timeout(timeout);

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengubah password'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
