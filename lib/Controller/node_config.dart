
import 'dart:convert';

import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:http/http.dart' as http;

class NodeConfig{
  static Future<FukuroResponse>  enableNotification(id,metric,val) async {
    FukuroRequest req = FukuroRequest("config/$id/alert/$metric?val=$val");
    http.Response htres = await req.post(); 
    return FukuroResponse(res: htres);
  }
  static Future<FukuroResponse>  disableNotification(id,metric) async {
    FukuroRequest req = FukuroRequest("config/$id/alert/$metric");
    http.Response htres = await req.del(); 
    return FukuroResponse(res: htres);
  }
  
  static Future<FukuroResponse>  enableMonitoring(id,metric) async {
    FukuroRequest req = FukuroRequest("config/$id/monitoring/$metric/toggle");
    http.Response htres = await req.post(); 
    return FukuroResponse(res: htres);
  }
  static Future<FukuroResponse>  disableMonitoring(id,metric) async {
    FukuroRequest req = FukuroRequest("config/$id/monitoring/$metric/toggle");
    http.Response htres = await req.del(); 
    return FukuroResponse(res: htres);
  }
}