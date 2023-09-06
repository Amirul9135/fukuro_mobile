
 

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketClient{
  
  WebSocketClient._();

  WebSocketChannel? _channel;
  bool _isConnected = false;
  Map<String,Function> _listeners = {};

  static final WebSocketClient _instance = WebSocketClient._();

  factory WebSocketClient(){
    return _instance;
  }
  
  void connect(String url){
    if (!_isConnected){
      print('connecting to $url');
      try{
        _channel = IOWebSocketChannel.connect(url); 
        _isConnected = true;
        _channel!.stream.listen((message) {
          _handleMessage(message);
        },onError: (error){
          print('e$error');

        },onDone: (){
          print('done');
          _isConnected = false;
        });
      }catch(e){
        print('err$e');
        _isConnected = false;
      }
    }
  }
 
 
  void _handleMessage(msg){
    dynamic data;
    try {
      data = jsonDecode(msg);
    } catch (e) {
      //if fail to decode then its not json
      print('Non JSON Message received');
      return;
    }
    if(data.path){
      if (_listeners.keys.contains(data.path)){
        if (data.data){
          _listeners[data.path]!(data);
        }
        else{
          _listeners[data.path]!();
        }
        
      }
    }
  }

  void addListener(String path, Function action){
    _listeners[path] = action;
  }

  void sendMessage(dynamic msg){
    if(_isConnected){
      _channel?.sink.add(jsonEncode(msg));
    }
    else{
      throw Exception("Web socket is not connected");
    }
  }

  void close(){
    _channel?.sink.close();
  }


}