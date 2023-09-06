import 'dart:convert';

import 'package:http/http.dart' as http;

import 'SecureStorage.dart';

class FukuroRequest {
  final Map<dynamic, dynamic> _body = {};
  final Map<String, String> _headers = {};

  //static String _fukuroUrl = "http://10.0.2.2:5000/api/";
  //static String wsfukuroUrl = "ws://10.0.2.2:5000";

  static String _fukuroUrl = "http://192.168.8.102:5000/api/";
  static String wsfukuroUrl = "ws://192.168.8.102:5000";
  static String getApiUrl() {
    
    return _fukuroUrl;
  }

  String _path = "";

  SecureStorage storage = SecureStorage();

  FukuroRequest(String path) {
    _path = path;
  }

  setBody(Map<String, dynamic> data) {
    _body.clear();
    _body.addAll(data);
  }

  addBody(Map<dynamic, dynamic> data) {
    _body.addAll(data);
  }

  addHeader(Map<String, String> headerdata) {
    _headers.addAll(headerdata);
  }

  _loadToken() async {
    _headers["Authorization"] = await storage.read("jwt");
    _headers["uid"] = await storage.read("uid");
    print("request made to" + _path);
  }

  post({int? timeout}) async {
    await _loadToken();
    if (_body.isNotEmpty) {
      addHeader(<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
    }
    try {
      return await http
          .post(
            Uri.parse(FukuroRequest._fukuroUrl + _path),
            headers: _headers,
            body: jsonEncode(_body),
          )
          .timeout(Duration(seconds: timeout ?? 30));
    } catch (e) {
      return http.Response("unreached", 523);
    }
  }

  
  put({int? timeout}) async {
    await _loadToken();
    if (_body.isNotEmpty) {
      addHeader(<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
    }
    try {
      return await http
          .put(
            Uri.parse(FukuroRequest._fukuroUrl + _path),
            headers: _headers,
            body: jsonEncode(_body),
          )
          .timeout(Duration(seconds: timeout ?? 30));
    } catch (e) {
      return http.Response("unreached", 523);
    }
  }

  get({int? timeout}) async {
    await _loadToken();
    print(_headers);
    try {
      return await http
          .get(
            Uri.parse(FukuroRequest._fukuroUrl + _path),
            headers: _headers,
          )
          .timeout(Duration(
              seconds: timeout ??
                  30)); //set timeout if specified or default 30 second
    } catch (e) {
      return http.Response("unreached", 523);
    }
  }
  del({int? timeout}) async {
    await _loadToken();
    print(_headers);
    try {
      return await http
          .delete(
            Uri.parse(FukuroRequest._fukuroUrl + _path),
            headers: _headers,
          )
          .timeout(Duration(
              seconds: timeout ??
                  30)); //set timeout if specified or default 30 second
    } catch (e) {
      return http.Response("unreached", 523);
    }
  }
}

class FukuroResponse{
  http.Response res;
  dynamic _body = {};
  FukuroResponse({required this.res}){ 
    try{
    _body = jsonDecode(res.body); 
    print('res $_body');

    }catch(E){
      print('error in response $E' );

    } 
  }
  status(){
    return res.statusCode;
  }
  body(){
    return _body;
  }
  msg(){
    if(_body['message'] != null){
      return _body['message'].toString();
    }
    return '';
  }
  bool ok(){
    return res.statusCode == 200;
  }



}