import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fukuro_mobile/Controller/SecureStorage.dart';

import 'fukuro_request.dart';
import 'package:http/http.dart' as http;

class Authentication {
  static Future<bool> verifyToken() async {
    SecureStorage storage = SecureStorage();

    if (await storage.check("jwt") && await storage.check("uid")) {
      FukuroRequest reqVerify = FukuroRequest("user/verify");

      http.Response res = await reqVerify.get(timeout: 5);

      if (res.statusCode == 200) {
        return true;
      } else if (res.statusCode == 401) {
        //unauthorized token
        Fluttertoast.showToast(
            msg: "Unauthorized Token",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        await Authentication.clearToken();
        print("unauthorized");
        return false;
      }
    }
    return false;
  }

  static Future<bool> clearToken() async {
    SecureStorage storage = SecureStorage();

    await storage.clearValue("jwt");
    await storage.clearValue("uid");

    return true;
  }

  static Future<bool> logOut() async {
    SecureStorage storage = SecureStorage();

    if (await storage.check("jwt") && await storage.check("uid")) {
      FukuroRequest req = FukuroRequest("user/logout");
      http.Response res = await req.get();

      print(res.statusCode);
    }
    await clearToken();

    return true;
  }

  static Future<int> getUserId() async {
    SecureStorage storage = SecureStorage();
    dynamic val = await storage.read("uid");
    print(val.runtimeType);
    if (val.isNotEmpty) {
      return int.parse(val);
    } else {
      return -1;
    }
  }
}
