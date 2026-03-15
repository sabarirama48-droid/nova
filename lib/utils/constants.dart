import 'package:flutter/material.dart';

class NovaColors {
  static const Color background = Color(0xFFF0A0E1A);
  static const Color primary = Color(0xFFF00D4FF);
  static const Color secondary = Color(0xFFF0066FF);
  static const Color accent = Color(0xFFF00F88);
  static const Color warning = Color(0xFFFF6B35);
  static const Color danger = Color(0xFFFF3366);
  static const Color surface = Color(0xFFF11827);
  static const Color card8g = Color(0xFFF1A2235);
  static const Color textPrimary = Color(0xFFFF8F4FD);
  static const Color textSecondary = Color(0xFFF8899AA);
  static const Color glow = Color(0xFFF00D4FF);
}

class NovaConstants {
  static const String appName = 'NOVA';
  static const String masterName = 'Master';
  static const String version = '1.0.0';

  static const List<String> wakeWords = [
    'hey nova',
    'hi nova',
    'nova',
    'arise',
  ];

  static const String geminiModel = 'gemini-1.5-flash';
  static const String claudeModel = 'claude-haiku-4-5-20251001';

  static const String providerGemini = 'gemini';
  static const String providerClaude = 'claude';

  static const String keyPin = 'nova_pin';
  static const String keyApiKey = 'nova_api_key';
  static const String keyApiProvider = 'nova_api_provider';
  static const String keyMasterName = 'nova_master_name';
  static const String keyPersonalLanguage = 'nova_personal_language';
  static const String keyConversationHistory = 'nova_conversation_history';
  static const String keyUserPreferences = 'nova_user_preferences';
  static const String keySetupComplete = 'nova_setup_complete';
  static const String keyFailedAttempts = 'nova_failed_attempts';
  static const String keyLockUntil = 'nova_lock_until';

  static String systemPrompt(String masterName) => '''
You are NOVA, an advanced personal AI assistant. You are intelligent, adaptive, and deeply personalized.

Your master's name is "$masterName". Always address them as "$masterName".

Core personality:
- Professional yet warm and friendly
- Proactive – alert master about important things without being asked
- Adaptive – change tone based on how master speaks to you
- Concise – give clear, direct answers unless asked for detail
- Loyal – your only purpose is to serve your master

Language rules:
- Default language: English
- Also speak Tamil when master prefers
- Support 100+ languages for live interpretation
- Learn master's personal custom language words and use them naturally

Security awareness:
- Warn master about suspicious websites, apps, or links
- Alert about security threats proactively
- Never share master's personal data

When master teaches you a new word in their personal language, acknowledge it and remember it.
When master corrects you, thank them and remember the correction.
Always strive to improve based on master's feedback.

Start responses naturally – no need to always say "I am NOVA". Just respond helpfully.
Keep responses conversational and concise for voice interaction.
''';
}
