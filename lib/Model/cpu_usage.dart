import 'package:fukuro_mobile/Model/chart_data.dart';

class CpuUsage implements ChartData { 
  //node id altered due to unnecessary  in front end
  DateTime _dateTime = DateTime.now(); 
  double _user = 0;
  double _interrupt = 0;
  double _system = 0;
  double _total = 0;

  CpuUsage.fromJson(Map<String, dynamic> json) {  
    
    _user = json["user"].toDouble(); 
    _interrupt = json["interrupt"].toDouble(); 
    _system = json["system"].toDouble(); 

    if (json.containsKey("interval_group")) {
      _dateTime = DateTime.parse(json["interval_group"]);
    }
    if (json.containsKey("dateTime")) {
      _dateTime = DateTime.parse(json["dateTime"]);
    } 
    _sumUsage();
  }

  _sumUsage() {
    _total = _user + _system + _interrupt;
  }
 
  DateTime get dateTime => _dateTime;
  set dateTime(DateTime value) {
    _dateTime = value;
  }
 

  double get user => _user;
  set user(double value) {
    _user = value;
  }

  double get total => _total;
  set total(double value) {
    _total = value;
  }

  double get interrupt => _interrupt;
  set interrupt(double value) {
    _interrupt = value;
  }

  double get system => _system;
  set system(double value) {
    _system = value;
  }
  
  @override
  DateTime getTimeStamp() {
    return _dateTime;
  }
  
  @override
  double getVal(ChartDataType type) {
    switch(type){
      case ChartDataType.CPUTotal:
        return total;
      case ChartDataType.CPUUser:
        return user;
      case ChartDataType.CPUSytem:
        return system;
      case ChartDataType.CPUInterrupt:
        return interrupt;
      default:
        return 0;
    }
  }
}
