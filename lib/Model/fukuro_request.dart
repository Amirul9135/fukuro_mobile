import 'dart:convert';

import 'package:http/http.dart' as http;

class FukuroRequest {
  final Map<String, dynamic> _body = {};
  final Map<String, String> _headers = {};
  static String _fukuroUrl = "http://10.0.2.2:5000/api/";
  String _path = "";

  FukuroRequest(String path, String token, String uid) {
    _headers["Authorization"] = token;
    _headers["uid"] = uid;
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

  post() async {
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
