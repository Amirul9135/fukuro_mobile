import 'package:fukuro_mobile/Controller/Authentication.dart';
import 'package:http/http.dart'; 
import 'package:onesignal_flutter/onesignal_flutter.dart';

//this emthod set the currently logged in user id into one signal external id to allow recieving notification
class OneSignalController {

  static Future<void> init()async{ 
      OneSignal.Debug.setLogLevel(OSLogLevel.warn); 
     OneSignal.initialize("aeb81c01-4529-41bb-b7be-fb6be3dbece7"); 
     print(" one signal ${ OneSignal.Notifications.permission}");
    // OneSignal.Notifications.requestPermission(true);
  }

  static Future<bool> setExternalId() async {
    int id = await Authentication.getUserId();
    if (id == -1) {
      return false;
    }

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
 
    OneSignal.Notifications.requestPermission(true);
    OneSignal.login(id.toString());
    return true;
  }

  static Future<void> clearSubscription() async {
    await OneSignal.logout();
  }

  static handleNotificationOpened() {}
}
