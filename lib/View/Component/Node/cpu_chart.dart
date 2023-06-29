

import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/cpu_usage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Model/line_data.dart';

class CpuChart extends StatefulWidget {
  final Color mainColor;
  final Color user;
  final Color interrupt;
  final Color system;
  final Color highlight;
  final String title;
  final int duration;
  final double? threshold;

  CpuChart({
    Key? key,
    required this.title,
    required this.mainColor,
    required this.user,
    required this.interrupt,
    required this.system,
    required this.highlight,
    this.duration = 60,
    this.threshold
  }) : super(key: key);

  @override
  CpuChartState createState() => CpuChartState();
}

class CpuChartState extends State<CpuChart> {
  @override
  void initState() {
    super.initState();
    //  loadDummyData();
    setState(() {});
  }

  final List<CpuUsage> _data = [];
  final Map<String, dynamic> config = {"duration": 10};
  bool noData = false;

  loadDataset(List<CpuUsage> lst) {
    _data.clear();
    _data.addAll(lst);
    setState(() {});
  }

  setNoData() {
    noData = true;
  }

  setDuration(int sec) {
    config["duration"] = sec;
  }

  addData(CpuUsage reading) {
    _data.add(reading);
    final DateTime currentTime = DateTime.now();
    final DateTime timeLimit =
        currentTime.subtract(Duration(seconds: config["duration"]));

    _data.removeWhere((element) => element.dateTime.isBefore(timeLimit));
    if (mounted) {
      setState(() {});
    }
  }

  addDataList(List<CpuUsage> lst) {
    _data.addAll(lst);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    if (_data.isEmpty) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const CircularProgressIndicator(),
            Text(
              'Loading ' + widget.title + ' data ....',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    if (noData) {
      return const Center(
        child: Stack(
          alignment: Alignment.center,
          children: [ 
            Text(
              'No Data found',
              style:  TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
        constraints: BoxConstraints(maxHeight: maxHeight, minHeight: 300),
        height: 40.h,
        padding: const EdgeInsets.only(right: 20),
        child: SfCartesianChart(
            legend: Legend(
                isVisible: true,
                isResponsive: true,
                position: LegendPosition.bottom),
            title: ChartTitle(text: widget.title),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('HH:mm:ss\nyyyy-MM-dd'),
              edgeLabelPlacement: EdgeLabelPlacement.none,
              intervalType: DateTimeIntervalType.auto,
              minimum: _data[0].dateTime,
              maximum: _data.last.dateTime,
            ),
            primaryYAxis: NumericAxis(
              enableAutoIntervalOnZooming: true,
              axisLine: const AxisLine(width: 1), // Customize the axis line
              minimum: 0,
              maximum: widget.threshold ,
              majorGridLines: MajorGridLines(
                  width: 1,
                  color: widget.mainColor
                      .withOpacity(0.3)), // Configure Y-axis gridlines
            ),
            crosshairBehavior: CrosshairBehavior(
                enable: true,
                lineColor: widget.highlight,
                lineDashArray: <double>[5, 5],
                lineWidth: 2,
                lineType: CrosshairLineType.both,
                activationMode: ActivationMode.singleTap),
            series: <ChartSeries>[
              AreaSeries<CpuUsage, DateTime>(
                  name: "Total",
                  animationDuration: 1,
                  color: widget.mainColor.withOpacity(0.2),
                  borderColor: widget.mainColor,
                  borderWidth: 1,
                  dataSource: _data,
                  xValueMapper: (CpuUsage _data, _) => _data.dateTime,
                  yValueMapper: (CpuUsage _data, _) => _data.total,
                  emptyPointSettings:
                      EmptyPointSettings(mode: EmptyPointMode.zero)),
              LineSeries<CpuUsage, DateTime>(
                //system
                name: "system",
                animationDuration: 1,
                color: widget.system.withOpacity(0.7),
                dataSource: _data, //
                xValueMapper: (CpuUsage _data, _) => _data.dateTime,
                yValueMapper: (CpuUsage _data, _) => _data.system,
              ),
              LineSeries<CpuUsage, DateTime>(
                //system
                name: "user",
                animationDuration: 1,
                color: widget.user.withOpacity(0.7),
                dataSource: _data, //
                xValueMapper: (CpuUsage _data, _) => _data.dateTime,
                yValueMapper: (CpuUsage _data, _) => _data.user,
              ),
              LineSeries<CpuUsage, DateTime>(
                //system
                name: "interrupt",
                animationDuration: 1,
                color: widget.interrupt.withOpacity(0.7),
                dataSource: _data, //
                xValueMapper: (CpuUsage _data, _) => _data.dateTime,
                yValueMapper: (CpuUsage _data, _) => _data.interrupt,
              ),
              LineSeries<LineData, DateTime>(
                //highlight threshold
                name: "Threshold",
                color: widget.highlight.withOpacity(0.4),
                dataSource: <LineData>[
                  LineData(
                    x: _data[0].dateTime,
                    y: widget.threshold??100,
                  ), // Line 1
                  LineData(
                    x: _data.last.dateTime,
                    y: widget.threshold??100,
                  ), // Line 3
                ],
                xValueMapper: (LineData _data, _) => _data.x,
                yValueMapper: (LineData _data, _) => _data.y,
              ),
            ]));
  }
}
