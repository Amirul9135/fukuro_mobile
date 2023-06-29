import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';

class FukuroEditorController extends TextEditingController {
  TimeUnit? timeUnit;

  FukuroEditorController({String text='', this.timeUnit}) : super(text: text);
 
}