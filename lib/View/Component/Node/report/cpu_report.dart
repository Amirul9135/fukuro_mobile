import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/metric_controller.dart';
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
  final Function? fnDelete;
  const CPUReport({Key? key, required this.node, this.fnDelete})
      : super(key: key);

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
  ChartDataType selectedType = ChartDataType.CPUTotal;

  @override
  void initState() {
    super.initState();
    dtStart['dtStart'] = FukuroFormFieldBuilder(
      fieldName: 'Date Start',
      type: FukuroForm.inputDateTime,
    ).build();
    dtEnd['dtEnd'] = FukuroFormFieldBuilder(
      fieldName: 'Date End',
      type: FukuroForm.inputDateTime,
    ).build();
    interval['interval'] = FukuroFormFieldBuilder(
            fieldName: 'interval',
            rightAllign: true,
            type: FukuroForm.inputNumerical,
            isTimeUnit: true)
        .build();

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
                    child: FukuroForm(fields: dtEnd),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: FukuroForm(fields: interval),
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
                        onPressed: () {
                          _loadData();
                        },
                      )),
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
                      }).toList())
                      ),
                ),
              ],
            ),
            if (widget.fnDelete != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  widget.fnDelete?.call(widget);
                },
                child: Text('Close Report'),
              ),
          ],
        ));
  }

  _loadData() async {
    String dateStart = dtStart['dtStart']?['controller'].text;
    String dateEnd = dtEnd['dtEnd']?['controller'].text;
    int intvl = interval['interval']?['controller'].getValInSecond();
    if (dateStart.isEmpty || intvl < 1) {
      FukuroDialog.error(context, "Invalid",
          "Invalid date start or interval, date start cannot be empty and interval must be at least 1 second");
      return;
    }
    DateTime dStart = DateTime.parse(dateStart);
    DateTime dEnd = DateTime.now();
    if (dateEnd.isNotEmpty) {
      dEnd = DateTime.parse(dateEnd);
    }
    Duration diff = dEnd.difference(dStart);
    if (diff.inSeconds < intvl) {
      FukuroDialog.error(context, "Invalid",
          "Date Start cannot be lesser or too close with (Date End or current date)");
    } else if (diff.inSeconds / intvl > 1000) {
      FukuroDialog.info(context, "Large data",
          "Your requested report contains more than 1000 record, this may takes some time, please ensure you have good internet connection");
    }
    data.clear();
    if (mounted) setState(() {});
    data.addAll(await MetricController.getHistoricalCPUReading(
        widget.node.getNodeId(), dateStart, intvl, dateEnd));
    if (mounted) {
      setState(() {});
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
