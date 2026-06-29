import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class SecureStore {
  static final SecureStore _instance = SecureStore._internal();
  factory SecureStore() => _instance;

  final GetStorage storage = GetStorage();

  SecureStore._internal();

  // Save ANY data (int, double, bool, map, list, string, object)
  Future<void> save(String key, dynamic value) async {
    final encoded = jsonEncode(value);
    await storage.write(key, encoded);
  }

  // Read ANY data
  Future<T?> get<T>(String key) async {
    final data = await storage.read(key);
    if (data == null) return null;
    return jsonDecode(data) as T;
  }

  // Delete one
  Future<void> delete(String key) async {
    await storage.remove(key);
  }
}
