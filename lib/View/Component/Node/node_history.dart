import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/monitoring_preference.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Model/cpu_usage.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Node/cpu_chart.dart';
 

class NodeHistory extends StatefulWidget {
  const NodeHistory({Key? key, required this.thisnode,required this.config}) : super(key: key);
  final CPULocalConfig config;
  final Node thisnode; 
  @override
  NodeHistoryState createState() => NodeHistoryState();
}

class NodeHistoryState extends State<NodeHistory> {
  // Define your state variables here 
  final cpuchartKey = GlobalKey<CpuChartState>();

  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
    WidgetsBinding.instance.addPostFrameCallback((_) async { 
      List<CpuUsage> data = await fetchAllReading(widget.thisnode.getNodeId(),int.parse(widget.config.values["HTPeriod"].toString()) ,
        int.parse(widget.config.values["HTInterval"].toString()));
      print(data);
      if(data.isEmpty){
        cpuchartKey.currentState?.setNoData();
      }
      else{
        cpuchartKey.currentState?.addDataList(data);
      }  
      if (mounted) {
        setState(() {});
      }
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

  @override
  void dispose() {
    // Clean up resources or subscriptions here
    super.dispose();
  }
}
