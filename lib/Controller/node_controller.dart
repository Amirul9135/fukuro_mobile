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

Future<List<CpuUsage>> fetchAllReading(
    int nodeId, int period,int interval) async {
  FukuroRequest req = FukuroRequest("node/cpu/$nodeId?dur=$period&int=$interval");
  http.Response res = await req.get(); 
  List<CpuUsage> cpudata = [];
  if (res.statusCode == 200) {
    List<dynamic>  dataList = json.decode(res.body);
    for(var item in dataList){
      cpudata.add(CpuUsage.fromJson(item));
    } 
     
  }
  return cpudata;
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
