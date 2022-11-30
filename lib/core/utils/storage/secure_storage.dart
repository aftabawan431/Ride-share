import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  Future write({required String key, required String value}) async {
   await _secureStorage.write(key: key, value: value);
  }

  Future delete({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  Future<String?> read({required String key}) async {
    return await _secureStorage.read(key: key);
  }
}