import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';

class FukuroEditorController extends TextEditingController {
  TimeUnit? timeUnit;

  FukuroEditorController({String text='', this.timeUnit}) : super(text: text);

  getValInSecond(){
    return convertVal(int.tryParse(text)??0, timeUnit??TimeUnit.second, TimeUnit.second);
  }

  getValueInt(){
    return int.tryParse(text)??0;
  }
  getValueStr(){
    return text;
  }
 
}