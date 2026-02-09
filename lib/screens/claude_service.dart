import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClaudeService {
  static const String _baseUrl = 'http://localhost:3000/api/claude';

  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Please login first');
    }
    return token;
  }

  Future<String> sendMessage(
    String userMessage, {
    List<Map<String, String>>? conversationHistory,
    int maxTokens = 4096,
    String model = 'claude-sonnet-4-20250514',
    String? systemPrompt,
  }) async {
    final authToken = await _getAuthToken();

    List<Map<String, String>> messages = [];
    if (conversationHistory != null) {
      messages.addAll(conversationHistory);
    }
    messages.add({'role': 'user', 'content': userMessage});

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'model': model,
          'max_tokens': maxTokens,
          'messages': messages,
          'system':
              systemPrompt ??
              'You are a helpful marketing assistant for COCO app.',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'];
      } else {
        throw Exception(
          'Failed to get response: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error calling Claude API: $e');
    }
  }

  Future<String> chat(String message, {String? systemPrompt}) async {
    return await sendMessage(message, systemPrompt: systemPrompt);
  }
}
