import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClaudeService {
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  
  // Get API key from environment variables
  String get _apiKey => dotenv.env['ANTHROPIC_API_KEY'] ?? '';

  Future<String> sendMessage(String userMessage, {List<Map<String, String>>? conversationHistory}) async {
    if (_apiKey.isEmpty) {
      throw Exception('API key not found. Please add ANTHROPIC_API_KEY to .env file');
    }

    // Build messages array
    List<Map<String, String>> messages = [];
    
    // Add conversation history if provided
    if (conversationHistory != null) {
      messages.addAll(conversationHistory);
    }
    
    // Add current user message
    messages.add({
      'role': 'user',
      'content': userMessage,
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 1024,
          'system': 'You are a helpful marketing assistant for COCO app. You help users with social media marketing strategies, content ideas, and growing their online presence. Keep responses concise and actionable.',
          'messages': messages,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'];
      } else {
        throw Exception('Failed to get response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error calling Claude API: $e');
    }
  }

  // Helper method for single message (no history)
  Future<String> chat(String message) async {
    return await sendMessage(message);
  }
}
