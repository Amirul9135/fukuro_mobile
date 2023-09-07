import 'package:fukuro_mobile/Model/chart_data.dart';

class NETUsage implements ChartData { 
  //node id altered due to unnecessary  in front end
  DateTime _dateTime = DateTime.now();  
  double _tkByte = 0;
  int _tDrop = 0;
  int _tError = 0;
  double _rkByte = 0;
  int _rDrop = 0;
  int _rError = 0;

  NETUsage.fromJson(Map<String, dynamic> json) {  
    
    _rkByte = json["rkByte"].toDouble(); 
    _rDrop = json["rDrop"].toInt(); 
    _rError = json["rError"].toInt(); 
    _tkByte = json["tkByte"].toDouble(); 
    _tDrop = json["tDrop"].toInt(); 
    _tError = json["tError"].toInt(); 


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
 

  double get rkByte => _rkByte;
  set rkByte(double value) {
    _rkByte = value;
  }

  int get rError => _rError;
  set rError(int value) {
    _rError = value;
  }
  int get rDrop => _rDrop;
  set rDrop(int value) {
    _rDrop = value;
  }
 
  double get tkByte => _tkByte;
  set tkByte(double value) {
    _tkByte = value;
  }

  int get tError => _tError;
  set tError(int value) {
    _tError = value;
  }
  int get tDrop => _tDrop;
  set tDrop(int value) {
    _tDrop = value;
  }
  
  @override
  DateTime getTimeStamp() {
    return _dateTime;
  }
  
  @override
  double getVal(ChartDataType type) {
    switch(type){
      case ChartDataType.NETReceivedByte:
        return _rkByte;
      case ChartDataType.NETReceivedDrop:
        return _rDrop.toDouble();
      case ChartDataType.NETReceivedError:
        return _rError.toDouble();
      case ChartDataType.NETTransmitByte:
        return tkByte;
      case ChartDataType.NETTransmitDrop:
        return tDrop.toDouble();
      case ChartDataType.NETTransmitError:
        return tError.toDouble();
      default:
        return 0;
    }
  }
}
