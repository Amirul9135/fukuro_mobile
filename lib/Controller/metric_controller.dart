
 
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/Model/cpu_usage.dart';
import 'package:fukuro_mobile/Model/disk_usage.dart';
import 'package:fukuro_mobile/Model/mem_usage.dart';
import 'package:fukuro_mobile/Model/net_usage.dart';
import 'package:http/http.dart' as http;


class MetricController{
  // example start 2023-09-04 08:20:21
  static Future<FukuroResponse> getHistoricalReading(int nodeId, String metric, String dateStart,int inverval,String?dateEnd) async {
    String dts =  DateTime.parse(dateStart).toUtc().toIso8601String();
    String url = "metric/$nodeId/$metric?start=$dts&interval=$inverval";
    if(dateEnd != null && dateEnd.isNotEmpty){
      String dte =  DateTime.parse(dateEnd).toUtc().toIso8601String();
      url += "&end=$dte";
    }
    FukuroRequest req = FukuroRequest(url);
    http.Response htres = await req.get();
    return FukuroResponse(res: htres);
  }

  static Future<List<CpuUsage>> getHistoricalCPUReading(int nodeId, String dateStart,int inverval,String?dateEnd)async{
    FukuroResponse res = await MetricController.getHistoricalReading(nodeId, "cpu", dateStart, inverval, dateEnd);
    List<CpuUsage> ls = [];
    if(res.ok()){ 
      for (var item in res.body()) {
        ls.add(CpuUsage.fromJson(item));
      }
    }
    else if(res.status() ==523 ){
      Fluttertoast.showToast(
          msg:
              "Request takes too long, consider reconfiguring period and interval or try again later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

    } 
    return ls;
  }
  static Future<List<MEMUsage>> getHistoricalMEMReading(int nodeId, String dateStart,int inverval,String?dateEnd)async{
    FukuroResponse res = await MetricController.getHistoricalReading(nodeId, "mem", dateStart, inverval, dateEnd);
    List<MEMUsage> ls = [];
    if(res.ok()){ 
      for (var item in res.body()) {
        ls.add(MEMUsage.fromJson(item));
      }
    }
    else if(res.status() ==523 ){
      Fluttertoast.showToast(
          msg:
              "Request takes too long, consider reconfiguring period and interval or try again later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

    } 
    return ls;
  }
  static Future<List<NETUsage>> getHistoricalNETReading(int nodeId, String dateStart,int inverval,String?dateEnd)async{
    FukuroResponse res = await MetricController.getHistoricalReading(nodeId, "net", dateStart, inverval, dateEnd);
    List<NETUsage> ls = [];
    if(res.ok()){ 
      for (var item in res.body()) {
        ls.add(NETUsage.fromJson(item));
      }
    }
    else if(res.status() ==523 ){
      Fluttertoast.showToast(
          msg:
              "Request takes too long, consider reconfiguring period and interval or try again later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

    } 
    return ls;
  }
  static Future<List<DISKUsage>> getHistoricalDiskReading(int nodeId, String diskName, String dateStart,int inverval,String?dateEnd)async{
    
    String url = "metric/$nodeId/disk/$diskName?start=$dateStart&interval=$inverval";
    if(dateEnd != null && dateEnd.isNotEmpty){
      url += "&end=$dateEnd";
    }
    
    FukuroRequest req = FukuroRequest(url);
    http.Response htres = await req.get();
    FukuroResponse res = FukuroResponse(res: htres);
    List<DISKUsage> ls = [];
    if(res.ok()){ 
      for (var item in res.body()) {
        ls.add(DISKUsage.fromJson(item));
      }
    }
    else if(res.status() ==523 ){
      Fluttertoast.showToast(
          msg:
              "Request takes too long, consider reconfiguring period and interval or try again later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

    } 
    return ls;
  }
}