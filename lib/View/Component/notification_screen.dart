import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/notification_database.dart';
import 'package:fukuro_mobile/Model/notification.dart' as Model;

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  final NotificationDatabase db = NotificationDatabase();
  final List<Model.Notification> data = [];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await db.initialize(NotificationDatabase.NotificationDB);

        for (var d in await db.getData("notification")) {
          data.add(Model.Notification.fromJson(d));
          print(d);
        }
        print("datas $data");
        setState(() {});
      } catch (e) {
        print("error $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
          children: data.map((report) {
            return Container(
              margin:
                  const EdgeInsets.only(bottom: 15.0), // Set the margin here
              child: Text("test"),
            );
          }).toList(),
        ),
    );
  }
}
