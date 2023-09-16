import 'dart:async';

import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fukuro_mobile/Controller/WebSocketClient.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/chart_data.dart';
import 'package:fukuro_mobile/Model/cpu_usage.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/Node/report/metric_chart.dart';
import 'package:fukuro_mobile/View/Component/fukuro_form.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CPURealtime extends StatefulWidget {
  final Node node;
  final Function(Widget)? fnDelete;
  final WebSocketClient websocket;
  const CPURealtime({Key? key, required this.node, this.fnDelete,required this.websocket})
      : super(key: key);

  @override
  CPURealtimeState createState() => CPURealtimeState();
}

class CPURealtimeState extends State<CPURealtime> {
  final GlobalKey<MetricChartState> chartKey = GlobalKey();

  final List<CpuUsage> data = [];

  final Map<String, Map<dynamic, dynamic>> periodLength = {};
  final Map<String, Map<dynamic, dynamic>> refreshRate = {};
  final Map<String, Map<dynamic, dynamic>> agentInterval = {};

  double threshold = 0;
  late MetricChartSeries totalSeries;
  late MetricChartSeries userSeries;
  late MetricChartSeries interruptSeries;
  late MetricChartSeries systemSeries;
  ChartDataType selectedType = ChartDataType.CPUTotal;

  int lengthVal = 10;
  int refreshRateVal = 1;
  bool changed = false;

  late Timer _timer;
  @override
  void initState() {
    super.initState();
    periodLength['periodLength'] = FukuroFormFieldBuilder(
            fieldName: 'Chart Period',
            rightAllign: true,
            type: FukuroForm.inputNumerical,
            value: lengthVal.toString(),
            isTimeUnit: true)
        .build();
    periodLength['periodLength']?["refresh"] = true;

    refreshRate['refreshRate'] = FukuroFormFieldBuilder(
            fieldName: 'Chart Refresh Rate',
            rightAllign: true,
            type: FukuroForm.inputNumerical,
            value: refreshRateVal.toString(),
            isTimeUnit: true)
        .build();
    refreshRate['refreshRate']?["refresh"] = true;
    

    totalSeries = MetricChartSeries(
        name: 'Total ',
        type: MetricChartType.area,
        datas: data,
        dataType: ChartDataType.CPUTotal,
        color: Colors.blue);
    userSeries = MetricChartSeries(
        name: 'User ',
        type: MetricChartType.line,
        datas: data,
        dataType: ChartDataType.CPUUser,
        color: Colors.green);
    interruptSeries = MetricChartSeries(
        name: 'Interrupt ',
        type: MetricChartType.line,
        datas: data,
        dataType: ChartDataType.CPUInterrupt,
        color: Colors.yellow);
    systemSeries = MetricChartSeries(
        name: 'System ',
        type: MetricChartType.line,
        datas: data,
        dataType: ChartDataType.CPUSytem,
        color: Colors.brown);
    _timer = Timer.periodic(Duration(seconds: refreshRateVal), (timer) {
      if(mounted){

      setState(() {
        
      });
      }
    });

    //web socket
    widget.websocket.addListener("realtime/cpu", _addData);
    widget.websocket.sendMessage({"path":"metric/cpu","data":1});


    WidgetsBinding.instance.addPostFrameCallback((_) async { 
      periodLength['periodLength']?["controller"].addListener(() {
        _checkChange();
      });
      refreshRate['refreshRate']?["controller"].addListener(() {
        _checkChange();
      });
      chartKey.currentState?.addSeries(totalSeries);
      chartKey.currentState?.addSeries(userSeries);
      chartKey.currentState?.addSeries(systemSeries);
      chartKey.currentState?.addSeries(interruptSeries);
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(.2), // Border color
            width: 2.0, // Border width
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.fromLTRB(1.w, 2.h, 1.w, 2.h),
        child: Column(
          children: [
            Row(
              children: [ 
                Flexible(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: FukuroForm(fields: periodLength),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: FukuroForm(fields: refreshRate),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Center(
                    child: Container(
                        decoration: BoxDecoration(
                          color: (changed)
                              ? Colors.blue
                              : Colors.grey.shade500, // Background color
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.published_with_changes_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _applyChange();
                          },
                        )),
                  ),
                ),
              ],
            ),
            Container(
              child: MetricChart(
                key: chartKey,
                title: "CPU Usage(%) Over time",
                maxY: 100,
              ),
            ),
            ExpansionTileBorderItem(
              title: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Threshold : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(threshold.toString()),
                  IconButton(
                      onPressed: () => {_editThreshold()},
                      icon: Icon(Icons.edit)),
                  const Spacer(),
                  const Text('Category  :  '),
                  DropdownButton(
                      value: selectedType,
                      items: [
                        ChartDataType.CPUTotal,
                        ChartDataType.CPUUser,
                        ChartDataType.CPUSytem,
                        ChartDataType.CPUInterrupt,
                      ].map((ChartDataType items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(ChartData.getTypeName(items)),
                        );
                      }).toList(),
                      onChanged: (t) {
                        selectedType = t ?? ChartDataType.CPUTotal;
                        if (mounted) {
                          setState(() {});
                        }
                      }),
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
                  child: PaginatedDataTable(
                      columns: const [
                        DataColumn(label: Text('Date Time')),
                        DataColumn(label: Text('Total(%)')),
                        DataColumn(label: Text('User(%)')),
                        DataColumn(label: Text('System(%)')),
                        DataColumn(label: Text('Interrupt(%)')),
                      ],
                      source: _DataSource(
                          data: data.where((e) {
                        if (selectedType == ChartDataType.CPUTotal &&
                            e.total >= threshold) {
                          return true;
                        }
                        if (selectedType == ChartDataType.CPUUser &&
                            e.user >= threshold) {
                          return true;
                        }
                        if (selectedType == ChartDataType.CPUSytem &&
                            e.system >= threshold) {
                          return true;
                        }
                        if (selectedType == ChartDataType.CPUInterrupt &&
                            e.interrupt >= threshold) {
                          return true;
                        }
                        return false;
                      }).toList())),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    
    widget.websocket.sendMessage({"path":"metric/cpu","data":0});
    _timer
        .cancel();  
    super.dispose();
  }

  void _updateInterval() {
    _timer.cancel(); // Cancel existing timer 
    _timer = Timer.periodic(Duration(seconds: refreshRateVal), (timer) {
      setState(() {
        // Your state updates here
      });
    });
  }

  _addData(d) async{
    print("recevied data $d");
    data.add(CpuUsage.fromJson(d["data"]));
     
    final DateTime minNow = DateTime.now().subtract(Duration(seconds: lengthVal));

    data.removeWhere((element) => element.dateTime.isBefore(minNow)); 
  }
  _applyChange() {
    if (!changed) {
      Fluttertoast.showToast(
          msg: "No Change",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    }
    int nlength = myPareseNum(
            periodLength['periodLength']?["controller"].getValInSecond())
        .toInt();
    int nRefresh =
        myPareseNum(refreshRate['refreshRate']?["controller"].getValInSecond())
            .toInt();
    if (nlength < 5 || nRefresh < 1) {
      Fluttertoast.showToast(
          msg: "Invalid Period or Rate",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
          return;

    }
    lengthVal = nlength;
    refreshRateVal = nRefresh; 
    _updateInterval();
    if(mounted){
      setState(() {
        changed = false;
      });
    }
  }

  _editThreshold() {
    FukuroDialog msg = FukuroDialog(
      title: "Edit Threshold",
      message: "Editing this changes the display in liste reading",
      mode: FukuroDialog.INFO,
      NoBtn: true,
      textInput: true,
      BtnText: "Yes",
    );
    showDialog(context: context, builder: (_) => msg).then((value) async {
      if (msg.okpressed) {
        threshold = double.tryParse(msg.getInputText()) ?? 0;
        chartKey.currentState?.setThreshold(threshold);
        setState(() {});
      }
    });
  }

  _checkChange() {
    if (lengthVal !=
            myPareseNum(periodLength['periodLength']?["controller"]
                    .getValInSecond())
                .toInt() ||
        refreshRateVal !=
            myPareseNum(
                    refreshRate['refreshRate']?["controller"].getValInSecond())
                .toInt()) {
      changed = true;
    } else {
      changed = false;
    }
    setState(() {});
  }
}

class _DataSource extends DataTableSource {
  final List<CpuUsage> data;
  double? threshold;

  _DataSource({required this.data});
  DateFormat dt = DateFormat('dd/MM/yyyy  hh:mm:ss aa');
  @override
  DataRow getRow(int index) {
    final item = data[index];
    return DataRow(cells: [
      DataCell(Text(dt.format(item.dateTime.toLocal()))),
      DataCell(Text(item.total.toStringAsFixed(2))),
      DataCell(Text(item.user.toStringAsFixed(2))),
      DataCell(Text(item.system.toStringAsFixed(2))),
      DataCell(Text(item.interrupt.toStringAsFixed(2))),
    ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
