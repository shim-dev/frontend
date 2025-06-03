import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  static Future<String?> getUserNickname() async {
    return await _storage.read(key: 'nickname');
  }

  static Future<String?> getUserEmail() async {
    return await _storage.read(key: 'email');
  }

  static Future<void> deleteUserId() async {
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'nickname');
    await _storage.delete(key: 'email');
  }
}
