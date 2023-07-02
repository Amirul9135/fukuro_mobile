
class CPUServerConfig {


  CPUServerConfig();

  int _userId = -1; 
  int get userId => _userId;
  set userId(int value){
    _userId = value;
  }

  double _threshold = 100;
  double get threshold => _threshold;
  set threshold(double value){
    _threshold = value;
  }

  bool _notification = false;
  bool get notification => _notification;
  set notification(bool value) {
    _notification = value;
  }

  static loadCPUConfigs(){
    
  }
}