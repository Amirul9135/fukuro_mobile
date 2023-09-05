import 'package:flutter/material.dart';

Widget verticalGap(double intpx) => SizedBox(height: intpx); //vertical gap
Widget horizontalGap(double intpx) => SizedBox(width: intpx); // horizontal gap

enum TimeUnit { second, minute, hour, day }

int convertVal(int val, TimeUnit from, TimeUnit to) {
  switch (from) {
    case TimeUnit.second:
      switch (to) {
        case TimeUnit.minute:
          return val ~/ 60;
        case TimeUnit.hour:
          return val ~/ 3600;
        case TimeUnit.day:
          return val ~/ 86400;
        default:
          return val;
      }
    case TimeUnit.minute:
      switch (to) {
        case TimeUnit.second:
          return val * 60;
        case TimeUnit.hour:
          return val ~/ 60;
        case TimeUnit.day:
          return val ~/ 1440;
        default:
          return val;
      }
    case TimeUnit.hour:
      switch (to) {
        case TimeUnit.second:
          return val * 3600;
        case TimeUnit.minute:
          return val * 60;
        case TimeUnit.day:
          return val ~/ 24;
        default:
          return val;
      }
    case TimeUnit.day:
      switch (to) {
        case TimeUnit.second:
          return val * 86400;
        case TimeUnit.minute:
          return val * 1440;
        case TimeUnit.hour:
          return val * 24;
        default:
          return val;
      }
    default:
      return val;
  }
}

String timeUnitNAme(TimeUnit unit) {
  switch (unit) {
    case TimeUnit.second:
      return 'Sec';
    case TimeUnit.minute:
      return 'Min';
    case TimeUnit.hour:
      return 'Hour';
    case TimeUnit.day:
      return 'Day';
    default:
      return '';
  }
}

String censorString(String inp){ 
  return '*' * inp.length;
}
