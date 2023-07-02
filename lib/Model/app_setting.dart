import 'dart:convert';

import 'package:fukuro_mobile/Controller/SecureStorage.dart';

class AppSetting {
  bool _allowNotification = false;

  bool get allowNotification => _allowNotification;
  set allowNotification(bool value) {
    _allowNotification = value;
  }

  AppSetting(){
    _allowNotification = false;
  }

  AppSetting.fromJson(Map<String, dynamic> json) {
    _allowNotification = json["allowNotification"] as bool;
  } 

  save () async {
    Map<String, dynamic> setting = {};
    setting["allowNotification"] = _allowNotification;
    SecureStorage storage = SecureStorage();
    await storage.write("appSetting", jsonEncode(setting));
  }

  loadSetting()async{
    SecureStorage storage = SecureStorage();
    Map<String, dynamic> setting = jsonDecode(await storage.read("appSetting")??"{}");
    _allowNotification = setting["allowNotification"] ?? false;


  }
}
