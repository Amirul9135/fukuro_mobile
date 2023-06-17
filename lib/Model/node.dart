class Node{
int _nodeId = 0;
String _name ="";
String _description ="";
String _ipAddress ="";
String _passKey ="";



Node();
Node.fromJson(Map<String, dynamic> json){
  _nodeId = json["nodeId"]??0;
  _name = json["name"]??'';
  _description = json["description"]??'';
  _ipAddress = json["ipAddress"]??'';
  _passKey = json["passKey"]??'';
}



int getNodeId(){
  return _nodeId;
}

String getName(){
  return _name;
}
String getDescription(){
  return _description;
}
String getIpAddress(){
  return _ipAddress;
}
String getPassKey(){
  return _passKey;
}

setNodID(int id){
  _nodeId = id;
}
setName(String name){
  _name = name;
}
setDescription(String desc){
  _description = desc;
}
setIpAddress(String ip){
  _ipAddress = ip;
}
setPassKey(String key){
  _passKey = key;
}

}