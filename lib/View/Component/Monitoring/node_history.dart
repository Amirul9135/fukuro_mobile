import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Monitoring/cpu_chart.dart';  

import '../../../Controller/node_controller.dart';
import '../../../Model/cpu_usage.dart'; 


class NodeHistory extends StatefulWidget {
  const NodeHistory({Key? key, required this.thisnode}) : super(key: key);
  final Node thisnode;
  @override
  NodeHistoryState createState() => NodeHistoryState();
}

class NodeHistoryState extends State<NodeHistory> {
  // Define your state variables here 
  Map<String, List<CpuUsage>> cpuData = {};
  final cpuchartKey = GlobalKey<CpuChartState>();
 
  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
     WidgetsBinding.instance
        .addPostFrameCallback((_) async {  
         // _nodes.clear();
         // _nodes.addAll(await fetchAllUserOwnedNodes()); 
            cpuData.clear();
            cpuData.addAll(await fetchAllReading(widget.thisnode.getNodeId(),1));
            if(cpuData.containsKey("cpu")){
            cpuchartKey.currentState?.loadDataset("cpu utilization",  cpuData["cpu"]??[]);
           // for(CpuUsage tt in cpuData["cpu"]??[]){
            //  print(tt.dateTime);
           //   print(tt.total);
          //  }
            }
          setState(() {
            
          });
        });
  }

  @override
  Widget build(BuildContext context) {   

    CpuChart cpuc = CpuChart(key: cpuchartKey, title: "CPU", mainColor: Colors.lightBlue,
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