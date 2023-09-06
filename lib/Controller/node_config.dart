 
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:http/http.dart' as http;

class NodeConfig {
  static Future<FukuroResponse> enableNotification(id, metric, val) async {
    FukuroRequest req = FukuroRequest("config/$id/alert/$metric?val=$val");
    http.Response htres = await req.post();
    return FukuroResponse(res: htres);
  }

  static Future<FukuroResponse> disableNotification(id, metric) async {
    FukuroRequest req = FukuroRequest("config/$id/alert/$metric");
    http.Response htres = await req.del();
    return FukuroResponse(res: htres);
  }

  static Future<FukuroResponse> enableMonitoring(id, metric) async {
    FukuroRequest req = FukuroRequest("config/$id/monitoring/$metric/toggle");
    http.Response htres = await req.post();
    return FukuroResponse(res: htres);
  }

  static Future<FukuroResponse> disableMonitoring(id, metric) async {
    FukuroRequest req = FukuroRequest("config/$id/monitoring/$metric/toggle");
    http.Response htres = await req.del();
    return FukuroResponse(res: htres);
  }

  static Future<FukuroResponse> loadMetricConfigurations(id, metric) async {
    FukuroRequest req = FukuroRequest("config/$id/$metric");
    http.Response htres = await req.get();
    return FukuroResponse(res: htres);
  }

  static Future<FukuroResponse> updateMetricConfigValues(
      id, metric, payload) async {
    FukuroRequest req = FukuroRequest("config/$id/monitoring/$metric");
    req.addBody(payload);
    http.Response htres = await req.post();
    return FukuroResponse(res: htres);
  }

  static Future<FukuroResponse> loadPush(id) async {
    FukuroRequest req = FukuroRequest("config/$id/push");
    http.Response htres = await req.get();
    return FukuroResponse(res: htres);
  }

  static Future<FukuroResponse> updatePush(id, val) async {
    FukuroRequest req = FukuroRequest("config/$id/push");
    req.addBody({"interval": val});
    http.Response htres = await req.post();
    return FukuroResponse(res: htres);
  }

  static Future<FukuroResponse> togglePush(id, bool enable) async {
    FukuroRequest req = FukuroRequest("config/$id/push/toggle");
    http.Response htres;
    if (enable) {
      htres = await req.post();
    } else {
      htres = await req.del();
    }
    return FukuroResponse(res: htres);
  }
}
