 
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/OneSignal.dart'; 
 
import 'package:fukuro_mobile/Model/node.dart';  
import 'package:fukuro_mobile/View/home.dart';
import 'package:fukuro_mobile/View/node_main.dart';
import 'package:fukuro_mobile/View/node_register.dart';
import 'package:fukuro_mobile/View/profile.dart';
import 'package:fukuro_mobile/View/register.dart';   
import 'View/login.dart';
import 'package:sizer/sizer.dart'; 
//import 'package:dcdg/dcdg.dart';
 
void main() async{ 
   WidgetsFlutterBinding.ensureInitialized();
    // Set up notification handlers  
   await OneSignalController.init();
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
              builder: (context) => NodeMainScreen(thisNode: args,),
            );
          }
          if (settings.name == '/home') {
            final args = settings.arguments;
            if (args != null && args is int) {
              return MaterialPageRoute(
                builder: (context) => Home(tabIndex: args),
              );
            } else {
              return MaterialPageRoute(
                builder: (context) => Home(),
              );
            } 
          }
          // Handle other routes here if needed
          return null;
        },
      routes: {
        '/': (context) => const Login(),
        '/profile': (context) => const Profile(),
        '/register': (context) => const Register(), 
        '/node/register': (context) => const NodeRegister()
      },
      );
    }); 
  }
}
  