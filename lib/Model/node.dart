import 'package:fukuro_mobile/Controller/fukuro_request.dart';

import '../Controller/SecureStorage.dart';
import 'package:http/http.dart' as http;

class Node {
  int _nodeId = 0;
  String _name = "";
  String _description = ""; 
  String _passKey = "";
  int access = 0;

  Node();
  Node.fromJson(Map<String, dynamic> json) {
    _nodeId = json["nodeId"] ?? 0;
    _name = json["name"] ?? '';
    _description = json["description"] ?? ''; 
    _passKey = json["passKey"] ?? '';
  }
  Map<String, dynamic> toJson() {
    return {
      'nodeId': _nodeId,
      'name': _name,
      'description': _description, 
      'passKey': _passKey,
    };
  }

  Future<bool> submitToServer() async {
    FukuroRequest req = FukuroRequest("node");
    req.addBody(toJson());
    http.Response res = await req.post();
 
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> saveToServer() async {
    FukuroRequest req = FukuroRequest("node");
    req.addBody(toJson());
    http.Response res = await req.put();
    print(_nodeId);
 
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  int getNodeId() {
    return _nodeId;
  }

  String getName() {
    return _name;
  }

  String getDescription() {
    return _description;
  }
 

  String getPassKey() {
    return _passKey;
  }

  setNodID(int id) {
    _nodeId = id;
  }

  setName(String name) {
    _name = name;
  }

  setDescription(String desc) {
    _description = desc;
  }
 

  setPassKey(String key) {
    _passKey = key;
  }

  static Future<Map<String, dynamic>> wsVerfifyMsg(Node node) async {
    SecureStorage storage = SecureStorage();
    String token = await storage.read("jwt");
    String uid = await storage.read("uid");

    Map<String, dynamic> auth = {
      "verify": {
        "jwt": token,
        "uid": uid,
        "nodeId": node.getNodeId(),
        "passKey": node.getPassKey(),
        "client": "app",
        "metric": {"cpu": 1}
      }
    };
    return auth;
  }
}
