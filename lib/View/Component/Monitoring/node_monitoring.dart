import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/fukuro_request.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Monitoring/cpu_chart.dart';
import 'package:web_socket_channel/io.dart';

import '../../../Controller/node_controller.dart';
import '../../../Model/cpu_usage.dart';

class NodeMonitoring extends StatefulWidget {
  const NodeMonitoring({Key? key, required this.thisnode}) : super(key: key);
  final Node thisnode;
  @override
  NodeMonitoringState createState() => NodeMonitoringState();
}

class NodeMonitoringState extends State<NodeMonitoring> {
  // Define your state variables here
 // final wschannel = IOWebSocketChannel.connect(FukuroRequest.wsfukuroUrl);
  Map<String, List<CpuUsage>> cpuData = {};
  final cpuchartKey = GlobalKey<CpuChartState>();

  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
  //  wschannel.stream.listen((message) {
      // Handle received messages here
   // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
   //   wschannel.sink.add(Node.wsVerfifyMsg(widget.thisnode));
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

  
  Future<void> _startWebSocketSession() async {
    bool confirmed =false; 
  }
  @override
  void dispose() {
    // Clean up resources or subscriptions here
    super.dispose();
  //  wschannel.sink.close();
  }
}
