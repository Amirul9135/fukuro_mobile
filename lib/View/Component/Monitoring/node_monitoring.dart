import 'package:flutter/material.dart';
import 'package:fukuro_mobile/View/Component/Monitoring/cpu_chart.dart'; 
import 'package:fukuro_mobile/View/Component/Monitoring/metric_chart.dart'; 


class NodeMonitoring extends StatefulWidget {
  const NodeMonitoring({Key? key}) : super(key: key);
  @override
  NodeMonitoringState createState() => NodeMonitoringState();
}

class NodeMonitoringState extends State<NodeMonitoring> {
  // Define your state variables here 

  final cpuKey = GlobalKey<MetricChartState>();
  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
     WidgetsBinding.instance
        .addPostFrameCallback((_) async {  
         // _nodes.clear();
         // _nodes.addAll(await fetchAllUserOwnedNodes()); 
          setState(() {
            
          });
        });
  }

  @override
  Widget build(BuildContext context) {   

    CpuChart cpuc = CpuChart(title: "CPU", mainColor: Colors.lightBlue,
    system: Colors.brown,
    user: Colors.green,
    interrupt: Colors.yellow,
     highlight: Colors.red, 
     );


    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const  EdgeInsets.all(10),
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
                  margin:  const EdgeInsets.symmetric(vertical: 10),
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