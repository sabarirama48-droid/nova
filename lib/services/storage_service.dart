import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/conversation.dart';
import '../models/personal_language.dart';
import '../utils/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> savePin(String pin) async {
    await _secureStorage.write(key: NovaConstants.keyPin, value: pin);
  }

  Future<String?> getPin() async {
    return await _secureStorage.read(key: NovaConstants.keyPin);
  }

  Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }

  Future<void> saveApiKey(String key, String provider) async {
    await _secureStorage.write(key: NovaConstants.keyApiKey, value: key);
    await _prefs.setString(NovaConstants.keyApiProvider, provider);
  }

  Future<String?> getApiKey() async {
    return await _secureStorage.read(key: NovaConstants.keyApiKey);
  }

  Future<String> getApiProvider() async {
    return _prefs.getString(NovaConstants.keyApiProvider) ?? 
        NovaConstants.providerGemini;
  }

  Future<void> saveMasterName(String name) async {
    await _prefs.setString(NovaConstants.keyMasterName, name);
  }

  String getMasterName() {
    return _prefs.getString(NovaConstants.keyMasterName) ?? 
        NovaConstants.masterName;
  }

  Future<void> setSetupComplete(bool value) async {
    await _prefs.setBool(NovaConstants.keySetupComplete, value);
  }

  bool isSetupComplete() {
    return _prefs.getBool(NovaConstants.keySetupComplete) ?? false;
  }

  Future<void> saveFailedAttempts(int count) async {
    await _prefs.setInt(NovaConstants.keyFailedAttempts, count);
  }

  int getFailedAttempts() {
    return _prefs.getInt(NovaConstants.keyFailedAttempts) ?? 0;
  }

  Future<void> saveLockUntil(DateTime? lockUntil) async {
    if (lockUntil == null) {
      await _prefs.remove(NovaConstants.keyLockUntil);
    } else {
      await _prefs.setString(
          NovaConstants.keyLockUntil, lockUntil.toIso8601String());
    }
  }

  DateTime? getLockUntil() {
    final lockStr = _prefs.getString(NovaConstants.keyLockUntil);
    if (lockStr == null) return null;
    return DateTime.parse(lockStr);
  }

  Future<void> saveConversationHistory(
      List<ConversationMessage> messages) async {
    final jsonList = messages.map((m) => m.toJson()).toList();
    await _prefs.setString(
        NovaConstants.keyConversationHistory, jsonEncode(jsonList));
  }

  List<ConversationMessage> getConversationHistory() {
    final jsonStr = _prefs.getString(NovaConstants.keyConversationHistory);
    if (jsonStr == null) return [];
    final jsonList = jsonDecode(jsonStr) as List;
    return jsonList.map((j) => ConversationMessage.fromJson(j)).toList();
  }

  Future<void> savePersonalLanguage(List<PersonalWord> words) async {
    final jsonList = words.map((w) => w.toJson()).toList();
    await _prefs.setString(
        NovaConstants.keyPersonalLanguage, jsonEncode(jsonList));
  }

  List<PersonalWord> getPersonalLanguage() {
    final jsonStr = _prefs.getString(NovaConstants.keyPersonalLanguage);
    if (jsonStr == null) return [];
    final jsonList = jsonDecode(jsonStr) as List;
    return jsonList.map((j) => PersonalWord.fromJson(j)).toList();
  }

  Future<void> addPersonalWord(PersonalWord word) async {
    final words = getPersonalLanguage();
    final existingIndex = 
        words.indexWhere((w) => w.word.toLowerCase() == word.word.toLowerCase());
    if (existingIndex >= 0) {
      words[existingIndex] = word;
    } else {
      words.add(word);
    }
    await savePersonalLanguage(words);
  }

  Future<void> savePreference(String key, String value) async {
    final prefs = _getPreferencesMap();
    prefs[key] = value;
    await _prefs.setString(
        NovaConstants.keyUserPreferences, jsonEncode(prefs));
  }

  String? getPreference(String key) {
    final prefs = _getPreferencesMap();
    return prefs[key];
  }

  Map<String, String> _getPreferencesMap() {
    final jsonStr = _prefs.getString(NovaConstants.keyUserPreferences);
    if (jsonStr == null) return {};
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, v.toString()));
  }

  Future<void> clearAll() async {
    await _prefs.clear();
    await _secureStorage.deleteAll();
  }
}
