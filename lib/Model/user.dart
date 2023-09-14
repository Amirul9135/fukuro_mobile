class User { 
  String _name = ""; 
  String _email = "";
  String _phone = "";
  int _userId = 0;
  int accessId = 0;

  User.fromJson(Map<String, dynamic> json) {
    _name = json["name"];
    _email = json["email"];
    _phone = json["phone"];
    _userId = json["userId"];
    if(json['accessId'] != null){
      accessId = json['accessId'];
    }
  }
  User();

  int get userId => _userId;
  set userId(int value) => _userId = value;

  String get name => _name;
  set name(String value) => _name = value;
 

  String get email => _email;
  set email(String value) => _email = value;

  String get phone => _phone;
  set phone(String value) => _phone = value;
}
