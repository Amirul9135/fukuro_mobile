import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fukuro_mobile/Model/cpu_usage.dart';
import 'package:fukuro_mobile/Model/dsik_drive.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'dart:convert';
import 'fukuro_request.dart';
import 'package:http/http.dart' as http;

class NodeController {

  
  static Future<FukuroResponse> updatePass(int nodeId, String curPasskey, String newPassKey) async {
    FukuroRequest req = FukuroRequest('node/$nodeId/pass');
    req.addBody({
      "passKey":curPasskey,
      "newpassKey":newPassKey
    });      
    http.Response htres = await req.put();
    return FukuroResponse(res: htres);

  }
  static Future<FukuroResponse> changeUserAccess(int nodeId,int userId,int targetRole) async{
    String url = "node/$nodeId/access/";
    if(targetRole == 0) {url += "$userId";}
    if(targetRole == 1) {url += "admin/$userId";}
    if(targetRole == 2) {url += "collaborator/$userId";}
    if(targetRole == 3) {url += "guest/$userId";}
     
    FukuroRequest req = FukuroRequest(url);
     http.Response httpr;
    if(targetRole == 0){
      httpr = await req.del();
    }
    else{
      httpr = await req.post();
    } 

    return  FukuroResponse(res: httpr) ;

  }

  static Future<FukuroResponse> getLogs(int nodeId,String start,String end) async{
    
    String dts =  DateTime.parse(start).toUtc().toIso8601String();
    String dte =  DateTime.parse(end).toUtc().toIso8601String();
    FukuroRequest req = FukuroRequest('node/$nodeId/log/$dts/$dte');
    http.Response httpr= await req.get();
    return  FukuroResponse(res: httpr) ;

  }
  static Future<FukuroResponse> getNodeSpec(int nodeId) async{
    FukuroRequest req = FukuroRequest('node/$nodeId/info');
    http.Response httpr= await req.get();
    return  FukuroResponse(res: httpr) ;

  }

  static Future<FukuroResponse> findUser(int nodeId,bool access,String key) async{
    String url = 'user/find/$nodeId?'; 
    print(url);
    print("test $access");
    if(access == true){
      url += "access=true";
    }
    if(key.isNotEmpty){
       List<String> parts = key.split(' ');
      url +=  parts.map((part) => '&k=$part').join();
    }
    FukuroRequest req = FukuroRequest(url);
    http.Response httpr = await req.get();
    return FukuroResponse(res: httpr);

  }

  static Future<FukuroResponse> toggleDisk(
      int nodeId, String diskname, bool enable) async {
    FukuroRequest req = FukuroRequest('config/$nodeId/disk/$diskname');
    http.Response httpr;
    if (enable) {
      httpr = await req.post();
    } else {
      httpr = await req.del();
    }
    FukuroResponse res = FukuroResponse(res: httpr);
    return res;
  }

  static Future<List<DiskDrive>> getDiskList(int nodeId) async {
    FukuroRequest req = FukuroRequest('config/$nodeId/disk/list');
    http.Response httpr = await req.get();
    FukuroResponse res = FukuroResponse(res: httpr);
    List<DiskDrive> drives = [];
    if (res.ok()) {
      for (var item in res.body()) {
        drives.add(DiskDrive.fromJson(item));
      }
    }
    return drives;
  }

  static Future<List<Node>> fetchAllUserOwnedNodes() async {
    FukuroRequest req = FukuroRequest("node");
    http.Response res = await req.get();
    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Node.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<List<CpuUsage>> fetchHistoricalReading(
      int nodeId, int period, int interval) async {
    FukuroRequest req =
        FukuroRequest("node/cpu/$nodeId?dur=$period&int=$interval");
    http.Response res = await req.get(timeout: 40);

    print(res);
    print(res.statusCode);
    List<CpuUsage> cpudata = [];
    if (res.statusCode == 523) {
      Fluttertoast.showToast(
          msg:
              "Request takes too long, consider reconfiguring period and interval",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (res.statusCode == 200) {
      List<dynamic> dataList = json.decode(res.body);
      for (var item in dataList) {
        cpudata.add(CpuUsage.fromJson(item));
      }
    }
    return cpudata;
  }

  static Future<int> checkAccessToNode(Node node) async {
    FukuroRequest req = FukuroRequest("node/access");
    req.setBody(node.toJson());
    http.Response res = await req.post();
    FukuroResponse rs = FukuroResponse(res: res); 
    if (rs.ok()) {
      return rs.body()['accessId'];
    }
    return 0;
  }
}
