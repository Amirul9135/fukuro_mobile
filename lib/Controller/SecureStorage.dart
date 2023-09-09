import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  
 const platform = const MethodChannel('com.example.flutter_secure_storage_example/storage');

class SecureStorage { 

  static final FlutterSecureStorage storage =
      FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  
  SecureStorage._();
  static final SecureStorage _instance = SecureStorage._();

  factory SecureStorage(){
    return _instance;
  }

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
