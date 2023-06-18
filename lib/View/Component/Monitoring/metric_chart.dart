import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/metric_data.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Model/line_data.dart';

class MetricChart extends StatefulWidget {
  final Color color1;
  final Color color2;
  final String title;

  const MetricChart(
      {Key? key,
      required this.title,
      required this.color1,
      required this.color2})
      : super(key: key);

  @override
  MetricChartState createState() => MetricChartState();
}

class MetricChartState extends State<MetricChart> {
  void test() {}

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  List<MetricData> data = [];
  @override
  Widget build(BuildContext context) {
    final double maxHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    if (data.isEmpty) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const CircularProgressIndicator(),
            Text(
              'Loading ' + widget.title + '....',
              style:const TextStyle(
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
            title: ChartTitle(text: widget.title),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('HH:mm:ss\nyyyy-MM-dd'),
              intervalType: DateTimeIntervalType.auto,
              minimum: data[0].timeStamp,
              maximum: data.last.timeStamp,
            ),
            primaryYAxis: NumericAxis(
              minimum: 0, // Set the minimum value of the Y-axis
              maximum: 100, // Set the maximum value of the Y-axis
              axisLine: const AxisLine(width: 1), // Customize the axis line
              majorGridLines: MajorGridLines(
                  width: 1,
                  color: widget.color1
                      .withOpacity(0.3)), // Configure Y-axis gridlines
            ),
            crosshairBehavior: CrosshairBehavior(
                enable: true,
                lineColor: widget.color2,
                lineDashArray: <double>[5, 5],
                lineWidth: 2,
                lineType: CrosshairLineType.both,
                activationMode: ActivationMode.singleTap),
            series: <ChartSeries>[
              AreaSeries<MetricData, DateTime>(
                  color: widget.color1.withOpacity(0.2),
                  borderColor: widget.color1,
                  borderWidth: 1,
                  dataSource: data,
                  xValueMapper: (MetricData data, _) => data.timeStamp,
                  yValueMapper: (MetricData data, _) => data.val,
                  emptyPointSettings:
                      EmptyPointSettings(mode: EmptyPointMode.zero)),
              LineSeries<LineData, DateTime>(
                color: widget.color2.withOpacity(0.4),
                dataSource: <LineData>[
                  LineData(
                    x: data[0].timeStamp,
                    y: 50,
                  ), // Line 1
                  LineData(
                    x: data.last.timeStamp,
                    y: 50,
                  ), // Line 3
                ],
                xValueMapper: (LineData data, _) => data.x,
                yValueMapper: (LineData data, _) => data.y,
                xAxisName: 'X', // X-axis label
                yAxisName: 'Y', // Y-axis label
              ),
            ]));
  }
}
