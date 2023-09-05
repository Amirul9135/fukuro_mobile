import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/cpu_local_config.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Model/cpu_usage.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Node/cpu_chart.dart';
import 'package:sizer/sizer.dart';

class NodeHistory extends StatefulWidget {
  const NodeHistory({Key? key, required this.thisnode, required this.config})
      : super(key: key);
  final CPULocalConfig config;
  final Node thisnode;
  @override
  NodeHistoryState createState() => NodeHistoryState();
}

class NodeHistoryState extends State<NodeHistory> {
  // Define your state variables here
  final cpuchartKey = GlobalKey<CpuChartState>();
  final List<CpuUsage> data = [];

  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      data.addAll(await NodeController.fetchHistoricalReading(
          widget.thisnode.getNodeId(),
          int.parse(widget.config.values["HTPeriod"].toString()),
          int.parse(widget.config.values["HTInterval"].toString()))) ; 
      if (data.isEmpty) {
        print("no data");
        cpuchartKey.currentState?.setNoData();
      } else {
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
      threshold: double.parse(widget.config.values["HTThreshold"].toString()),
    );
    
    double thresholdVal = double.parse(widget.config.values["HTThreshold"].toString());

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 5.h),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Container(
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
                      ),
                      ExpansionTileBorderItem(
                        title: const Row(
                          children: [
                            Icon(Icons.data_thresholding_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Treshold Readings",
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
                          FractionallySizedBox(
                            widthFactor: 1.0,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Date Time')),
                                DataColumn(label: Text('Total')),
                                DataColumn(label: Text('User')),
                                DataColumn(label: Text('System')),
                                DataColumn(label: Text('Interrupt')),
                              ],
                              rows: data.where((item) {
                                return item.total >= thresholdVal;
                              }).map((item) {
                                return DataRow(cells: [
                                  DataCell(Text(item.dateTime.toLocal().toString())),
                                  DataCell(Text(item.total.toStringAsFixed(3))),
                                  DataCell(Text(item.user.toStringAsFixed(3))),
                                  DataCell(Text(item.system.toStringAsFixed(3))),
                                  DataCell(Text(item.interrupt.toStringAsFixed(3))),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
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
