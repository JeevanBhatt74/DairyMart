import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class ChatbotRemoteDataSource {
  Future<String> sendMessage(String message);
  void resetChat();
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  static const String _apiKey = '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';
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  static const String _systemPrompt = '''
You are DairyMart AI, a friendly and knowledgeable assistant for DairyMart — a premium online dairy products store.

Your role:
- Help customers find the right dairy products (milk, cheese, yogurt, butter, ghee, cream).
- Answer questions about product quality, freshness, pricing, nutrition, and delivery.
- Assist with order tracking, returns, and general support queries.
- Recommend products based on customer preferences and dietary needs.

Tone: Warm, professional, and concise. Use emojis sparingly for a friendly feel.
Keep responses short (2-4 sentences) unless the user asks for detail.
If you don't know something specific about DairyMart's operations, say so honestly and suggest contacting support.
''';

  final Dio _dio;
  final List<Map<String, String>> _chatHistory = [];

  ChatbotRemoteDataSourceImpl(this._dio) {
    _chatHistory.add({'role': 'system', 'content': _systemPrompt});
  }

  @override
  Future<String> sendMessage(String message) async {
    try {
      _chatHistory.add({'role': 'user', 'content': message});

      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => true,
        ),
        data: {
          'model': 'llama-3.3-70b-versatile',
          'messages': _chatHistory,
          'temperature': 0.7,
          'max_tokens': 512,
        },
      );

      if (response.statusCode != 200) {
        if (_chatHistory.isNotEmpty && _chatHistory.last['role'] == 'user') {
          _chatHistory.removeLast();
        }
        throw Exception("Chatbot API Error ${response.statusCode}");
      }

      final reply = response.data['choices'][0]['message']['content'] as String;
      _chatHistory.add({'role': 'assistant', 'content': reply});
      return reply;
    } catch (e) {
      if (_chatHistory.isNotEmpty && _chatHistory.last['role'] == 'user') {
        _chatHistory.removeLast();
      }
      rethrow;
    }
  }

  @override
  void resetChat() {
    _chatHistory.clear();
    _chatHistory.add({'role': 'system', 'content': _systemPrompt});
  }
}
