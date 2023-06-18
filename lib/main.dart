import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Monitoring/node_main.dart';
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
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == '/node') {
            final args = settings.arguments as Node;
            return MaterialPageRoute(
              builder: (context) => NodeScreen(thisNode: args,),
            );
          }
          // Handle other routes here if needed
          return null;
        },
      routes: {
        '/': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) =>  Home(), 
      },
      );
    }); 
  }
}
  