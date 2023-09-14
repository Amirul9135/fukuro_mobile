import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import 'SecureStorage.dart';

class WebSocketClient {
  static dynamic buildVerification(Node node) async {
    SecureStorage storage = SecureStorage();
    return {
      "path": 'verify/app',
      "data": {
        "nodeId": node.getNodeId(),
        "passKey": node.getPassKey(),
        "jwt": await storage.read("jwt"),
        "uid": await storage.read("uid")
      }
    };
  }

  WebSocketClient._();

  WebSocketChannel? _channel;
  bool _isConnected = false;
  Map<String, Function> _listeners = {};

  static final WebSocketClient _instance = WebSocketClient._();

  factory WebSocketClient() {
    return _instance;
  }

  void connect(Node node)async {
    if (!_isConnected) {
      print('connecting to ws');
      try {
        _channel = IOWebSocketChannel.connect(FukuroRequest.wsfukuroUrl);
        _isConnected = true;
        sendMessage(await WebSocketClient.buildVerification(node));
        _channel!.stream.listen((message) {
          _handleMessage(message);
        }, onError: (error) {
          print('e$error');
        }, onDone: () {
          print('done');
          _isConnected = false;
        });
      } catch (e) {
        print('err$e');
        _isConnected = false;
      }
    }
  }

  void _handleMessage(msg)async {
    print("WS received $msg");
    dynamic data;
    try {
      data = jsonDecode(msg);
    } catch (e) {
      //if fail to decode then its not json
      print('Non JSON Message received');
      return;
    }

    try{ 
    if (data.containsKey("path")) {
      print(data["path"]);
      print(_listeners);
      if (_listeners.keys.contains(data["path"])) {
        if (data["data"] != null) {
          _listeners[data["path"]]?.call(data);
        } else {
          _listeners[data["path"]]?.call();
        }
      }
    } 
    }catch(e){
      print("mende error ni $e");
    }
  }

  void addListener(String path, Function action) {
    _listeners[path] = action;
  }

  void sendMessage(dynamic msg)async { 
      try{

      _channel?.sink.add(jsonEncode(msg));
      }catch(e){
        print("web socket error $e");
      } 
  }

  void close() {
    _channel?.sink.close();
    _isConnected = false;
  }
}
