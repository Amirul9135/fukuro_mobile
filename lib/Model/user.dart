class User { 
  String _name = ""; 
  String _email = "";
  String _phone = "";

  User.fromJson(Map<String, dynamic> json) {
    _name = json["name"];
    _email = json["email"];
    _phone = json["phone"];
  }
 

  String get name => _name;
  set name(String value) => _name = value;
 

  String get email => _email;
  set email(String value) => _email = value;

  String get phone => _phone;
  set phone(String value) => _phone = value;
}
