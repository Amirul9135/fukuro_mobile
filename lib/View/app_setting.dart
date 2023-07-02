import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/OneSignal.dart';
import 'package:fukuro_mobile/Model/app_setting.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class AppSettingScreen extends StatefulWidget {
  const AppSettingScreen({super.key});
  @override
  AppSettingScreenState createState() => AppSettingScreenState();
}

class AppSettingScreenState extends State<AppSettingScreen> {
  // Add your state variables and methods here
  final GlobalKey<ExpansionTileCustomState> settingFormKey = GlobalKey();
  final AppSetting setting = AppSetting();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setting.loadSetting();
      setState(() {
        settingFormKey.currentState?.expand();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
          ),
          title: const Text('Application Settings'),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 5.h),
            child: SingleChildScrollView(
                child: Column(
              children: [
                ExpansionTileBorderItem(
                  expansionKey: settingFormKey,
                  title: const Row(
                    children: [
                      Icon(Icons.notifications_none_outlined),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Notification Setting",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                  children: [
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      height: 0,
                    ),
                    Row(
                      children: [
                        Switch(
                            value: setting.allowNotification,
                            onChanged: (value) {
                              _toggleNotification();
                            }),
                        const Text("Allow Notification")
                      ],
                    )
                  ],
                )
              ],
            )))
        // Add your other widgets and layouts here
        );
  }

  _toggleNotification() async {
    if (setting.allowNotification) {
      //true so diable
      FukuroDialog confirmation = FukuroDialog(
        title: "Disable Notification",
        message:
            "You will not recieve any notification if you apply this change",
        mode: FukuroDialog.QUESTION,
        NoBtn: true,
        BtnText: "Yes",
        CancelBtnText: "Cancel",
      );
      showDialog(context: context, builder: (_) => confirmation)
          .then((value) async {
        if (confirmation.okpressed) {
          setting.allowNotification = false;
          setState(() {});
        } else {
          if (mounted) {
            showDialog(
                context: context,
                builder: (_) => FukuroDialog(
                    title: 'Error',
                    message: 'Unable to set up connection with one signal',
                    mode: FukuroDialog.ERROR));
          }
        }
      });
    } else {
      //false so turn to enable
      PermissionStatus permission = await _checkNotificationPermission();
      print(permission);
      if (permission.isGranted) {
        bool joinOneSignal = await OneSignalController.setExternalId();
        if (joinOneSignal) {
          setting.allowNotification = true;
          setState(() {});
        } else {}
      }
    }
  }

  _checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;

    if (!status.isGranted) {
      status = await Permission.notification.request();
    }
    return status;
  }

  @override
  void dispose() {
    // Clean up resources and cancel subscriptions here
    super.dispose();
  }
}
