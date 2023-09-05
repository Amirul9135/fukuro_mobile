import 'package:fukuro_mobile/Controller/Authentication.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

//this emthod set the currently logged in user id into one signal external id to allow recieving notification
class OneSignalController {
  static Future<bool> setExternalId() async {
    int id = await Authentication.getUserId();
    if (id == -1) {
      return false;
    }
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("aeb81c01-4529-41bb-b7be-fb6be3dbece7");

    OneSignal.shared.setExternalUserId(id.toString());
    return true;
  }
}
