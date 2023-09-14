class ActivityLog {
  DateTime dateTime = DateTime.now();
  String log = "";
  String user = "";

  ActivityLog.fromJson(Map<String, dynamic> json) {
    String  strdateTime = json["dateTime"].toString();
    if(strdateTime.isNotEmpty){
      
      dateTime = DateTime.parse(strdateTime);
    }
    log = json["log"].toString();
    if(json["name"] == null){
      user = "None";
    }
    else{
      user = json["name"].toString();
    }
   
  }
}
