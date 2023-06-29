import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/monitoring_preference.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Node/cpu_chart.dart';
import 'package:web_socket_channel/io.dart';
import '../../../Controller/fukuro_request.dart';
import '../../../Model/cpu_usage.dart';
import '../Misc/fukuro_dialog.dart';

class NodeMonitoring extends StatefulWidget {
  const NodeMonitoring({Key? key, required this.thisnode, required this.parentController,required this.fallback,required this.config}) : super(key: key);
  final Node thisnode;
  final TabController parentController;
  final int fallback;
  final CPULocalConfig config;
  @override
  NodeMonitoringState createState() => NodeMonitoringState();
}

class NodeMonitoringState extends State<NodeMonitoring> {
  // Define your state variables here
  final wschannel = IOWebSocketChannel.connect(FukuroRequest.wsfukuroUrl);
  Map<String, List<CpuUsage>> cpuData = {};
  final cpuchartKey = GlobalKey<CpuChartState>();

  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
    wschannel.stream.listen((message) {
      _handleMessage(message);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      wschannel.sink.add(jsonEncode(await Node.wsVerfifyMsg(widget.thisnode)));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CpuChart cpuc = CpuChart(
      key: cpuchartKey,
      title: "CPU",
      mainColor: Colors.lightBlue,
      system: Colors.brown,
      user: Colors.green,
      interrupt: Colors.yellow,
      highlight: Colors.red,
      duration: widget.config.values["RTPeriod"],
      threshold: double.parse(widget.config.values["HTThreshold"].toString()) ,
    );

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    border: Border.all(
                      color: Colors.lightBlue,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // padding:  const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: cpuc,
                );
              },
              childCount: 1,
            ),
          ),
        )
      ],
    );
  }

  Future<void> _startWebSocketSession() async {}
  @override
  void dispose() {
    // Clean up resources or subscriptions here
    super.dispose();
    wschannel.sink.close();
  }

  _handleMessage(msg) {
    dynamic data;
    try {
      data = jsonDecode(msg);
    } catch (e) {
      //if fail to decode then its not json
      print(msg);
      return;
    }
    print(data);
    if (data.containsKey("error")) {
      showDialog(
          context: context,
          builder: (_) => FukuroDialog(
              title: 'Error',
              message: data["error"],
              mode: FukuroDialog.ERROR)); 
      widget.parentController.animateTo(widget.fallback);
      return;
    }
    if(data.containsKey("warning")){ 
      showDialog(
          context: context,
          builder: (_) => FukuroDialog(
              title: 'warning',
              message: data["warning"],
              mode: FukuroDialog.WARNING)); 
      widget.parentController.animateTo(widget.fallback);
      return;

    }
    if(data.containsKey("cpu")){  
      cpuchartKey.currentState?.addData(CpuUsage.fromJson(data["cpu"]));
    }
  }
}
