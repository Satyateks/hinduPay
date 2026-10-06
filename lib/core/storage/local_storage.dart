import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  LocalStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ----------------------------------------------------------
  // String
  // ----------------------------------------------------------

  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // ----------------------------------------------------------
  // JSON
  // ----------------------------------------------------------

  static Future<void> writeJson(String key, Map<String, dynamic> value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  static Future<Map<String, dynamic>?> readJson(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return jsonDecode(value) as Map<String, dynamic>;
  }

  // ----------------------------------------------------------
  // Clear
  // ----------------------------------------------------------

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
