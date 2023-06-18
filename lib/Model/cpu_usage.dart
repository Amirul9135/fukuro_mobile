class CpuUsage {
  int _nodeId = 0;
  DateTime _dateTime = DateTime.now();
  String _label = "";
  double _user = 0;
  double _interrupt = 0;
  double _system = 0;
  double _total = 0;

  CpuUsage.fromJson(Map<String, dynamic> json) {
    _nodeId = json["nodeId"] ?? 0;
    _label = json["label"] ?? '';
    _user = json["user"] ?? 0;
    _interrupt = json["interrupt"] ?? 0;
    _system = json["system"] ?? 0;

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

  int get nodeId => _nodeId;
  set nodeId(int value) {
    _nodeId = value;
  }

  DateTime get dateTime => _dateTime;
  set dateTime(DateTime value) {
    _dateTime = value;
  }

  String get label => _label;
  set label(String value) {
    _label = value;
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
}
