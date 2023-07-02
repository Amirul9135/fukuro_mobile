import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class SecureStorage {
  final FlutterSecureStorage storage =
      FlutterSecureStorage(aOptions: _getAndroidOptions());
  Map<String, dynamic> cache = {};

  write(String key, dynamic value) async {
    cache[key] = value.toString();
    await storage.write(key: key, value: value.toString());
  }

  check(String key) async {
    if(cache.containsKey(key)){
      return true;
    }  
    return await storage.containsKey(key: key);
  }

  read(String key) async {
    if (cache.containsKey(key)) {
      if (cache[key]?.isNotEmpty ?? false) {
        return cache[key];
      }
    }
    cache[key] = await storage.read(key: key) ;
    return cache[key];
  }
 

  clearValue(String key) async {
    if (cache.containsKey(key)) {
      cache.remove(key);
    }
    await storage.delete(key: key);
  }
}
