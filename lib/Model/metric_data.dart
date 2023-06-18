
class MetricData{
  DateTime _timeStamp = DateTime.now();
  double _val = 0;

  DateTime get timeStamp => _timeStamp;

  set timeStamp(DateTime value) {
    _timeStamp = value;
  }

  double get val => _val;

  set val(double value) {
    _val = value;
  }
}