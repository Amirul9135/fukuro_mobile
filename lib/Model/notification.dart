import 'dart:convert';

import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/cpu_usage.dart';
import 'package:fukuro_mobile/Model/disk_usage.dart';
import 'package:fukuro_mobile/Model/mem_usage.dart';
import 'package:fukuro_mobile/Model/net_usage.dart';
import 'package:intl/intl.dart';

class Notification {
  int id = 0;
  String title = "";
  String body = "";
  dynamic type;
  String data = "";
  String dateString = "";
  bool selected = false;

  Notification.fromJson(Map<String, dynamic> json) {
    id = json["id"];

    DateFormat dt = DateFormat('dd/MM/yyyy  hh:mm:ss aa');
    title = json["title"];
    body = json["body"];
    try {
      Map<String, dynamic> content = jsonDecode(json["data"]);
      if (content.containsKey("dateTime")) {
        DateTime timeStamp = DateTime.parse(content["dateTime"]);
        dateString = dt.format(timeStamp.toLocal());
      }
      if(title.contains("CPU")){
        CpuUsage tmp = CpuUsage.fromJson(content);
        data = "Total ${tmp.total.toStringAsFixed(2)} %, User ${tmp.user.toStringAsFixed(2)}%, System ${tmp.system.toStringAsFixed(2)}%, Interrupt ${tmp.interrupt.toStringAsFixed(2)}%";
        type =Metrics.cpu;
      }
      else if(title.contains("Memory")){
        MEMUsage tmp = MEMUsage.fromJson(content);
        data = "Usage ${tmp.used.toStringAsFixed(2)} %, Cache ${tmp.cached.toStringAsFixed(2)}%, Buffer ${tmp.buffer.toStringAsFixed(2)}%";
        type =Metrics.memory;
      }
      else if(title.contains("Disk")){
        DISKUsage tmp = DISKUsage.fromJson(content);
        data = "Utilized ${tmp.utilization.toStringAsFixed(2)} %, Writes ${tmp.writeSpeed.toStringAsFixed(2)}KBps, Reads ${tmp.readSpeed.toStringAsFixed(2)}KBps";
        type =Metrics.disk;
      }
      else if(title.contains("Network")){
        NETUsage tmp = NETUsage.fromJson(content);
        data = "Received:\t${tmp.rkByte.toStringAsFixed(2)} KB, Error ${tmp.rError.toString()}, Drops ${tmp.rDrop.toString()}"
        + "\nTransmitted:\t${tmp.tkByte.toStringAsFixed(2)} KB, Error ${tmp.tError.toString()}, Drops ${tmp.tDrop.toString()}";
        type =Metrics.network;
      }
    } catch (E) {}
  }
}
