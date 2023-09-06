import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_editor_controller.dart';
import 'package:fukuro_mobile/Model/chart_data.dart';
import 'package:fukuro_mobile/Model/cpu_usage.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/Node/report/metric_chart.dart';
import 'package:fukuro_mobile/View/Component/fukuro_form.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CPUReport extends StatefulWidget {
  final Node node;

  const CPUReport({Key? key, required this.node}) : super(key: key);

  @override
  CPUReportState createState() => CPUReportState();
}

class CPUReportState extends State<CPUReport> {
  
  final GlobalKey<MetricChartState> chartKey = GlobalKey();
  final List<CpuUsage> data = [];
 
  final Map<String, Map<dynamic, dynamic>> interval = {};
  final Map<String, Map<dynamic, dynamic>> dtStart = {};
  final Map<String, Map<dynamic, dynamic>> dtEnd = {};

  double threshold = 0;
  late MetricChartSeries totalSeries;
  late MetricChartSeries userSeries;
  late MetricChartSeries interruptSeries;
  late MetricChartSeries systemSeries;
  

  @override
  void initState() {
    super.initState();
    dtStart['dtStart'] = FukuroFormFieldBuilder( 
            fieldName: 'Date Start', 
            type: FukuroForm.inputDateTime,  )
        .build();  
    dtEnd['dtEnd'] = FukuroFormFieldBuilder( 
            fieldName: 'Date End',
            
            type: FukuroForm.inputDateTime,  )
        .build();  
    interval['interval'] = FukuroFormFieldBuilder( 
            fieldName: 'interval',
            rightAllign: true,
            type: FukuroForm.inputNumerical, 
            isTimeUnit: true )
        .build();  


    totalSeries =  MetricChartSeries(
        name: 'Total Series',
        type: MetricChartType.area,
        datas: data,
        dataType: ChartDataType.CPUTotal,
        color: Colors.blue);
    userSeries =  MetricChartSeries(
        name: 'User Series',
        type: MetricChartType.line,
        datas: data,
        dataType: ChartDataType.CPUTotal,
        color: Colors.green);
    interruptSeries = MetricChartSeries(
        name: 'Interrupt Series',
        type: MetricChartType.line,
        datas: data,
        dataType: ChartDataType.CPUTotal,
        color: Colors.yellow);
    systemSeries =  MetricChartSeries(
        name: 'Interrupt Series',
        type: MetricChartType.line,
        datas: data,
        dataType: ChartDataType.CPUTotal,
        color: Colors.brown);

    for (int i = 0; i < 50; i++) {
      data.add(CpuUsage.fromJson(
          {"total": 100, "user": 11, "interrupt": 11, "system": 5}));
    }
      data.add(CpuUsage.fromJson(
          {"total": 100, "user": 50, "interrupt": 11, "system": 5}));
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      
      chartKey.currentState?.addSeries(totalSeries);
      chartKey.currentState?.addSeries(userSeries);
      chartKey.currentState?.addSeries(systemSeries);
      chartKey.currentState?.addSeries(interruptSeries);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 2.h, 0, 2.h),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: FukuroForm(fields: dtStart),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child:  FukuroForm(fields: dtEnd),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container( 
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child:  FukuroForm(fields: interval),
                  ),
                ),
                Flexible(
                  flex: 1,
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
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      )),
                ),
              ],
            ),
               Container(child: MetricChart(key: chartKey, title: "CPU Usage(%) Over time",maxY: 100,initThreshold: threshold,),),
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
                      onPressed: () =>
                          {_editThreshold()},
                      icon: Icon(Icons.edit))
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
                          data: data
                              .where((e) => e.total >= threshold)
                              .toList())),
                ),
              ],
            ),
          ],
        ));
  }
  _loadData(){ 
  }
  _addData(CpuUsage usage){
    data.add(usage);
    setState(() {
      
    });
  }
  _addDatas(List<CpuUsage> usage){
    data.addAll(usage);
    setState(() {
      
    });

  }
  _editThreshold(){ 
    FukuroDialog msg =  FukuroDialog(
        title: "Edit Threshold",
        message: "Editing this changes the display in liste reading",
        mode: FukuroDialog.INFO,
        NoBtn: true,
        textInput: true,
        BtnText: "Yes",
      );
    showDialog(context: context, builder:(_)=> msg).then((value) async {
      if(msg.okpressed){
          threshold = double.tryParse(msg.getInputText()) ?? 0;
          print('val $threshold');
          chartKey.currentState?.setThreshold(threshold);
          setState(() {
            
          });
      }
    });
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
      DataCell(Text(dt.format(item.dateTime))),
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
