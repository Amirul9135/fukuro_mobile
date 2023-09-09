import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fukuro_mobile/Controller/notification_database.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/View/Component/Misc/expandable_fab.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart'; 
import 'package:sizer/sizer.dart';
import 'package:fukuro_mobile/Model/notification.dart' as Model;

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  final NotificationDatabase db = NotificationDatabase();
  final List<Model.Notification> data = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await db.initialize(NotificationDatabase.NotificationDB);
      await _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
                height: 16), // Adjust the space between the indicator and text
            Text('Loding...'),
          ],
        ),
      );
    }
    if(data.isEmpty){
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ 
            SizedBox(
                height: 16), // Adjust the space between the indicator and text
            Text('No New Notification'),
          ],
        ),
      );

    }
    return Scaffold(
      body: Container(
          padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
          child: SingleChildScrollView(
            child: Column(
              children: data.map((d) {
                return NotificationView(notification: d);
              }).toList(),
            ),
          )),
      floatingActionButton: ExpandableFab(
        icon: const Icon(Icons.ads_click),
        distance: 60,
        children: [
          ActionButton(
            onPressed: () {
              _deleteAll();
            },
            icon: const Icon(Icons.delete_sweep_rounded),
          ),
          ActionButton(
            onPressed: () {
              _deleteSelected();
            },
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
    );
  }

  _deleteSelected() async {
    List<int> targets = [];

    for (Model.Notification noti in data) {
      if (noti.selected) {
        targets.add(noti.id);
      }
    }
    if (targets.isEmpty) {
      Fluttertoast.showToast(
          msg: "None selected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    loading = true;
    if (mounted) {
      setState(() {});
    }
    await db.deleteDatas("notification", targets);
    _load();
  }

  _deleteAll() {
    FukuroDialog msg = FukuroDialog(
      title: "Delete All Notification?",
      message: "All History ofnotification will be cleared",
      mode: FukuroDialog.WARNING,
      NoBtn: true,
      BtnText: "Yes",
    );

    showDialog(context: context, builder: (_) => msg).then((value) async {
      if (msg.okpressed) {
        List<int> targets = [];

        for (Model.Notification noti in data) {
          targets.add(noti.id);
        }
        loading = true;
        if(mounted){
          setState(() {
            
          });
        }
    await db.deleteDatas("notification", targets);
    _load();
      }
    });
  }

  _load() async {
    try {
      data.clear();
      for (var d in await db.getData("notification")) {
        data.add(Model.Notification.fromJson(d));
        print(d);
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print("error $e");
    }
  }
}

class NotificationView extends StatefulWidget {
  final Model.Notification notification;
  NotificationView({Key? key, required this.notification}) : super(key: key);

  @override
  NotificationViewState createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        widget.notification.selected = !widget.notification.selected;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: widget.notification.selected
              ? Colors.blue.withOpacity(.4)
              : Colors.white,
          border: Border.all(
            color: Colors.blue, // Border color
            width: 2.0, // Border width
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.only(bottom: 15.0), // Set the margin here
        child: Row(
          children: [
            Flexible(
              flex: 20,
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue, // Background color
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: IconButton(
                      icon: Icon(
                        widget.notification.type == Metrics.cpu
                            ? Icons.memory_rounded
                            : widget.notification.type == Metrics.memory
                                ? Icons.dashboard_rounded
                                : widget.notification.type == Metrics.disk
                                    ? Icons.layers_rounded
                                    : widget.notification.type ==
                                            Metrics.network
                                        ? Icons.network_check_rounded
                                        : Icons.notifications_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    )),
              ),
            ),
            Flexible(
                flex: 80,
                child: Container(
                    margin: EdgeInsets.only(right: 20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                widget.notification.title,
                                softWrap: true,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.timer_outlined),
                            Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  widget.notification.dateString,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.notification.data,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    )
                    )
                    ),
          ],
        ),
      ),
    );
  }
}
