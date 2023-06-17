import 'package:flutter/material.dart';
import 'package:fukuro_mobile/View/home.dart';
import 'package:fukuro_mobile/View/register.dart';
import 'View/login.dart';
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
      return  MaterialApp(
      title: 'FUKURO',
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) =>  Home(),
      },
      );
    }); 
  }
}
  