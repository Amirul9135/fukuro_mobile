import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class SecureStorage {
  final FlutterSecureStorage storage =
      FlutterSecureStorage(aOptions: _getAndroidOptions());
  Map<String, String> cache = {};

  write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  check(String key) async {
    if(cache.containsKey(key)){
      return true;
    } 
    bool has = await storage.containsKey(key: key);
    return has;
  }

  read(String key) async {
    if (cache.containsKey(key)) {
      if (cache[key]?.isNotEmpty ?? false) {
        return cache[key];
      }
    }
    cache[key] = await storage.read(key: key) ?? '';
    return cache[key];
  }
 

  clearValue(String key) async {
    await storage.delete(key: key);
  }
}
