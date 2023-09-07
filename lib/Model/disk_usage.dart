import 'package:fukuro_mobile/Model/chart_data.dart';

class DISKUsage implements ChartData { 
  //node id altered due to unnecessary  in front end
  DateTime _dateTime = DateTime.now(); 
  double _utilization = 0;
  double _readSpeed = 0;
  double _writeSpeed = 0; 

  DISKUsage.fromJson(Map<String, dynamic> json) {  
    
    _utilization = json["utilization"].toDouble(); 
    _readSpeed = json["readSpeed"].toDouble(); 
    _writeSpeed = json["writeSpeed"].toDouble(); 

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
 

  double get utilization => _utilization;
  set utilization(double value) {
    _utilization = value;
  }

  double get readSpeed => _readSpeed;
  set readSpeed(double value) {
    _readSpeed = value;
  }

  double get writeSpeed => _writeSpeed;
  set writeSpeed(double value) {
    _writeSpeed = value;
  }
 
  @override
  DateTime getTimeStamp() {
    return _dateTime;
  }
  
  @override
  double getVal(ChartDataType type) {
    switch(type){
      case ChartDataType.DISKUtilization:
        return _utilization;
      case ChartDataType.DISKWriteSpeed:
        return _writeSpeed;
      case ChartDataType.DISKReadSpeed:
        return _readSpeed; 
      default:
        return 0;
    }
  }
}
