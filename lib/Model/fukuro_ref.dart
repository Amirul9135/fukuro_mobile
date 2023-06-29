

class ByRef{
  dynamic _value;
  
  dynamic get value => _value;
  set value(dynamic value) {
    _value = value;
  }
}