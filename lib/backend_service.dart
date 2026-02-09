import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BackendService {
  // Change this to your computer's IP address when testing on phone
  // For web: use localhost:3000
  // For android: use http://192.168.2.33:3000/api
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  String? _token;

  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<Map<String, dynamic>?> signUp(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return data;
      } else {
        print('Sign up failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return data;
      } else {
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  Future<bool> saveOnboardingData(Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No auth token');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/onboarding'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error saving onboarding: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No auth token');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to get profile: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  Future<List<String>?> getRecommendations() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No auth token');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/recommendations'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['recommendations']);
      } else {
        print('Failed to get recommendations: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting recommendations: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserStats() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No auth token');
        return null;
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/user/stats'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to get stats: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting user stats: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getLatestAdPerformance() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No auth token');
        return null;
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/ads/latest'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to get ad performance: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting ad performance: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getUserAds() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No auth token');
        return null;
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/ads'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['ads']);
      } else {
        print('Failed to get ads: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting ads: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getNews() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No auth token');
        return null;
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/news'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['news']);
      } else {
        print('Failed to get news: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting news: $e');
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null;
  }
}
