import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BackendService {
  // Change this to your computer's IP address when testing on phone
  // For web: use localhost:3000
  static const String baseUrl = 'http://localhost:3000/api';
  
  String? _token;

  // Save token locally
  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Load token
  Future<String?> _getToken() async {
    if (_token != null) return _token;
    
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  // Clear token (logout)
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Sign up
  Future<Map<String, dynamic>?> signUp(String username, String email, String password) async {
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

  // Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
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

  // Save onboarding data
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

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No auth token');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
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

  // Get recommendations
  Future<List<String>?> getRecommendations() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No auth token');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/recommendations'),
        headers: {
          'Authorization': 'Bearer $token',
        },
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
}
