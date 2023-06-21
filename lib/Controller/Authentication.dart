import 'package:fukuro_mobile/Controller/SecureStorage.dart';

import 'fukuro_request.dart';
import 'package:http/http.dart' as http;

Future<bool> verifyToken() async {
  SecureStorage storage = SecureStorage();

  if (await storage.check("jwt") && await storage.check("uid")) {
    FukuroRequest reqVerify = FukuroRequest(
        "user/verify");

    http.Response res = await reqVerify.get();

    print("verified");
    if (res.statusCode == 200) {
      return true;
    }
  }
  return false;
}

Future<bool> clearToken() async{
  SecureStorage storage = SecureStorage();

  await storage.clearValue("jwt");
  await storage.clearValue("uid");

  return true;
}

Future<bool> logOut() async {
  SecureStorage storage = SecureStorage();

  if (await storage.check("jwt") && await storage.check("uid")) {
    FukuroRequest req = FukuroRequest(
        "user/logout");
    http.Response res = await req.get();

    print(res.statusCode);
    
  }
  await clearToken();

  return true;
}
