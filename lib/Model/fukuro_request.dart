import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Controller/SecureStorage.dart';

class FukuroRequest {
  final Map<String, dynamic> _body = {};
  final Map<String, String> _headers = {};
   static  String _fukuroUrl = "http://10.0.2.2:5000/api/";
  String _path = "";
  
  SecureStorage storage = SecureStorage();

  FukuroRequest(String path)  {
    _path = path;
  }

  setBody(Map<String, dynamic> data) {
    _body.clear();
    _body.addAll(data);
  }

  addBody(Map<String, dynamic> data) {
    _body.addAll(data);
  }

  addHeader(Map<String, String> headerdata) {
    _headers.addAll(headerdata);
  }

   _loadToken  () async {
    _headers["Authorization"] = await storage.read("jwt");
    _headers["uid"] =  await storage.read("uid");
    print("request made to"+ _path);
  }

  post() async {
    await _loadToken();
    if (_body.isNotEmpty) {
      addHeader(<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
    }

    return await http.post(
      Uri.parse(FukuroRequest._fukuroUrl+_path),
      headers: _headers,
      body: jsonEncode(_body),
    ); 
  }

  get() async { 
    await _loadToken();
    print(_headers);
    return await http.get(
      Uri.parse(FukuroRequest._fukuroUrl+_path),
      headers: _headers
    ); 
  }  
  //      http.Response response = await http.post(
  //        Uri.parse('http://10.0.2.2:5000/api/user/login'),
  //        headers: <String, String>{
  //          'Content-Type': 'application/json; charset=UTF-8',
  //        },
  //        body: jsonEncode(<String, String>{
  //          "username": tecUsername.text,
  //          "password": tecPassword.text
  //        }),
  //      );
}
