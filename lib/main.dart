import 'package:flutter/material.dart';
import 'screen/login.dart';
import 'package:sizer/sizer.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return const MaterialApp(
        home: Login(),
      );
    }); 
  }
}
  