import 'package:fukuro_mobile/Model/cpu_usage.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'dart:convert';
import 'fukuro_request.dart';
import 'package:http/http.dart' as http;

Future<List<Node>> fetchAllUserOwnedNodes() async {
  FukuroRequest req = FukuroRequest("node");
  http.Response res = await req.get();
  if (res.statusCode == 200) {
    List<dynamic> jsonList = json.decode(res.body);
    return jsonList.map((json) => Node.fromJson(json)).toList();
  } else {
    return [];
  }
}

Future<Map<String, List<CpuUsage>>> fetchAllReading(
    int nodeId, int period) async {
  FukuroRequest req = FukuroRequest("node/cpu/$nodeId?p=$period");
  http.Response res = await req.get();
  Map<String , List<CpuUsage>> data = {};
  if (res.statusCode == 200) {
    List<dynamic> jsonList = json.decode(res.body);  
    for(var item in jsonList){
      if (!data.containsKey(item["label"])) {
        data[item["label"]] = [];
    } 
    data[item["label"]]!.add(CpuUsage.fromJson(item));
    } 
     
  }

  return data;
}

Future<bool> checkAccessToNode(Node node)async {
  FukuroRequest req = FukuroRequest("node/access");
  req.setBody(node.toJson());
  http.Response  res = await req.post();
  if(res.statusCode == 200){
    return true;
  }
  return false;
}
