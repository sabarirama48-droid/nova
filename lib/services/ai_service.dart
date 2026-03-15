import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/conversation.dart';
import '../models/personal_language.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  
  factory AIService() => _instance;
  AIService._internal();

  final StorageService _storage = StorageService();

  Future<String> sendMessage(
    String userMessage,
    List<ConversationMessage> history,
    List<PersonalWord> personalWords,
  ) async {
    final provider = await _storage.getApiProvider();
    final apiKey = await _storage.getApiKey();

    if (apiKey == null || apiKey.isEmpty) {
      return 'Master, I need an API key to function. Please go to settings and add your API key.';
    }

    String personalLangContext = '';
    if (personalWords.isNotEmpty) {
      personalLangContext = '\n\nMaster\'s personal language dictionary:\n';
      for (final word in personalWords) {
        personalLangContext += '- "${word.word}" means "${word.meaning}"\n';
      }
      personalLangContext +=
          'Use these words naturally when appropriate and understand them when master uses them.';
    }

    final masterName = _storage.getMasterName();
    final systemPrompt =
        NovaConstants.systemPrompt(masterName) + personalLangContext;

    try {
      if (provider == NovaConstants.providerGemini) {
        return await _sendToGemini(apiKey, userMessage, history, systemPrompt);
      } else {
        return await _sendToClaude(apiKey, userMessage, history, systemPrompt);
      }
    } catch (e) {
      return 'Master, I encountered an error: ${e.toString()}. Please check your API key in settings.';
    }
  }

  Future<String> _sendToGemini(
    String apiKey,
    String userMessage,
    List<ConversationMessage> history,
    String systemPrompt,
  ) async {
    final model = GenerativeModel(
      model: NovaConstants.geminiModel,
      apiKey: apiKey,
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.8,
        maxOutputTokens: 1024,
      ),
    );

    final chatHistory = history
        .map((msg) => Content(
          role: msg.role == 'user' ? 'user' : 'model',
          parts: [TextPart(msg.content)],
        ))
        .toList();

    final chat = model.startChat(history: chatHistory);
    final response = await chat.sendMessage(Content.text(userMessage));

    return response.text ??
        'Master, I could not generate a response. Please try again.';
  }

  Future<String> _sendToClaude(
    String apiKey,
    String userMessage,
    List<ConversationMessage> history,
    String systemPrompt,
  ) async {
    final messages = [
      ...history.map((msg) => {
            'role': msg.role == 'user' ? 'user' : 'assistant',
            'content': msg.content,
          }),
      {
        'role': 'user',
        'content': userMessage,
      },
    ];

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': NovaConstants.claudeModel,
        'max_tokens': 1024,
        'system': systemPrompt,
        'messages': messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['content'][0]['text'];
    } else {
      throw Exception('Claude API error: ${response.statusCode}');
    }
  }

  bool isTeachingWord(String message) {
    final lower = message.toLowerCase();
    return lower.contains('nova learn') ||
        lower.contains('learn that') ||
        lower.contains('means') && lower.contains('in my language') ||
        lower.contains('teach you');
  }

  PersonalWord? extractPersonalWord(String message) {
    final patterns = [
      RegExp(r'nova learn[\:\-]\s*(\w+)\s*means?\s*(.+)',
          caseSensitive: false),
      RegExp(r'(\w+)\s+means?\s*(.+)\s+in my language',
          caseSensitive: false),
      RegExp(r'learn that\s+(\w+)\s+means?\s+(.+)',
          caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        return PersonalWord(
          word: match.group(1)!.trim(),
          meaning: match.group(2)!.trim(),
          learnedAt: DateTime.now(),
        );
      }
    }
    return null;
  }

  String detectMood(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('angry') ||
        lower.contains('frustrated') ||
        lower.contains('annoyed')) {
      return 'angry';
    } else if (lower.contains('happy') ||
        lower.contains('excited') ||
        lower.contains('great')) {
      return 'happy';
    } else if (lower.contains('sad') ||
        lower.contains('depressed') ||
        lower.contains('tired')) {
      return 'sad';
    } else if (lower.contains('stressed') || lower.contains('worried')) {
      return 'stressed';
    }

    return 'neutral';
  }

  bool containsWakeWord(String speech) {
    final lower = speech.toLowerCase().trim();
    for (final wakeWord in NovaConstants.wakeWords) {
      if (lower.contains(wakeWord)) {
        return true;
      }
    }
    return false;
  }

  String stripWakeWord(String speech) {
    String result = speech.toLowerCase();
    for (final wakeWord in NovaConstants.wakeWords) {
      result = result.replaceAll(wakeWord, '').trim();
    }
    return result.isEmpty ? speech : result;
  }
}
