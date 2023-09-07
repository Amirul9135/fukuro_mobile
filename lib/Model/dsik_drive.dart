class DiskDrive {
  String _name = "";
  double _size = 0;
  double _used = 0;
  bool _monitored = false;

  DiskDrive.fromJson(Map<String, dynamic> json) {
    _name = json["name"].toString();
    _size = json["size"].toDouble();
    _used = json["used"].toDouble();
    _monitored = json["monitor"] == 1;
  }
  String get name => _name;
  set name(String value) {
    _name = value;
  }

  double get size => _size;
  set size(double value) {
    _size = value;
  }

  double get used => _used;
  set used(double value) {
    _used = value;
  }

  bool get monitored => _monitored;
  set monitored(bool value) {
    _monitored = value;
  }

  double get usedPercent {
    return _used / _size * 100;
  }


  String get strUsed {
    return _convertToHighestUnit(used);
  }
  String get strSize {
    return _convertToHighestUnit(_size);
  }
  String _convertToHighestUnit(double sizeInKB) {
    const List<String> units = ['KB', 'MB', 'GB', 'TB'];

    double size = sizeInKB.toDouble();
    int unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
  }
}
