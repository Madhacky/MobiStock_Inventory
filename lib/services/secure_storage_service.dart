import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _jsessionIdKey = 'JSESSIONID';
  static final _storage = FlutterSecureStorage();

  static Future<void> setJSessionId(String jsessionId) async {
    await _storage.write(key: _jsessionIdKey, value: jsessionId);
  }

  static Future<String?> getJSessionId() async {
    return await _storage.read(key: _jsessionIdKey);
  }

  static Future<void> deleteJSessionId() async {
    await _storage.delete(key: _jsessionIdKey);
  }
}