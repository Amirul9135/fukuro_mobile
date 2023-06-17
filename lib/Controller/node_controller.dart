import 'package:fukuro_mobile/Controller/SecureStorage.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'dart:convert';
import '../Model/fukuro_request.dart';
import 'package:http/http.dart' as http;


 Future<List<Node>> fetchAllUserOwnedNodes() async {
  FukuroRequest req = FukuroRequest("node");
  http.Response res = await req.get();
  if(res.statusCode == 200){
    List<dynamic> jsonList = json.decode(res.body);
    return jsonList.map((json) => Node.fromJson(json)).toList();
  }
  else{
    return [];
  }
}