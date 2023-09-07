import 'package:fukuro_mobile/Model/chart_data.dart';

class MEMUsage implements ChartData { 
  //node id altered due to unnecessary  in front end
  DateTime _dateTime = DateTime.now(); 
  double _used = 0; 
  double _cached = 0; 
  double _buffer = 0; 

  MEMUsage.fromJson(Map<String, dynamic> json) {  
    
    _used = json["used"].toDouble(); 
    _cached = json["cached"].toDouble(); 
    _buffer = json["buffer"].toDouble(); 

    if (json.containsKey("interval_group")) {
      _dateTime = DateTime.parse(json["interval_group"]);
    }
    if (json.containsKey("dateTime")) {
      _dateTime = DateTime.parse(json["dateTime"]);
    }  
  }
 
 
  DateTime get dateTime => _dateTime;
  set dateTime(DateTime value) {
    _dateTime = value;
  }
 

  double get used => _used;
  set user(double value) {
    _used = value;
  }

  double get cached => _cached;
  set total(double value) {
    _cached = value;
  }

  double get buffer => _buffer;
  set interrupt(double value) {
    _buffer = value;
  }
 
  @override
  DateTime getTimeStamp() {
    return _dateTime;
  }
  
  @override
  double getVal(ChartDataType type) {
    switch(type){
      case ChartDataType.MEMBuffered:
        return buffer;
      case ChartDataType.MEMCached:
        return cached;
      case ChartDataType.MEMUsed:
        return used; 
      default:
        return 0;
    }
  }
}
