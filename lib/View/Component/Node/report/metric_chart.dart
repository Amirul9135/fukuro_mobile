 
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/chart_data.dart'; 
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetricChart extends StatefulWidget { 
  final String title;
  final double? maxY;
  final String? yAxisLabel; 
  final Color? thresholdColor;
  final Color? cursor;
  final double? initThreshold;

  const MetricChart(
      {Key? key,
      required this.title, 
      this.maxY,
      this.yAxisLabel, 
      this.thresholdColor,
      this.initThreshold,
      this.cursor})
      : super(key: key);

  @override
  MetricChartState createState() => MetricChartState();
}

class MetricChartState extends State<MetricChart> {
  
  DateTime? minX;
  DateTime? maxX;
  bool empty = true;

  List<MetricChartSeries> series = []; 

  double? threshold;

  @override
  void initState() {
    super.initState(); 
  }

  @override
  Widget build(BuildContext context) { 
    final double maxHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height; 
      threshold ??= widget.initThreshold;  
    if (_checkEmpty()) {
      return Center(
        
        child: Container(
          margin:const EdgeInsets.all(10),
          child: Stack(
          
          alignment: Alignment.center,
          children: [
            const CircularProgressIndicator(),
            Text(
              'Waiting for ' + widget.title + ' data to load ....',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),)
      );
    }
    _checkXBounds();
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
              intervalType: DateTimeIntervalType.auto,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                  text: widget.yAxisLabel ?? '',
                  alignment: ChartAlignment.center),
              minimum: 0,
              maximum: widget.maxY,
              axisLine: const AxisLine(width: 1),
              majorGridLines: MajorGridLines(
                  width: 1, color: Colors.black.withOpacity(0.4)),
            ),
            crosshairBehavior: CrosshairBehavior(
                enable: series.isNotEmpty,
                lineColor: widget.cursor?? Colors.blue,
                lineDashArray: <double>[5, 5],
                lineWidth: 2,
                lineType: CrosshairLineType.both,
                activationMode: ActivationMode.singleTap),
            series: _buildSeries()));
  }
  bool _checkEmpty(){ 
      empty = true; 
      for(MetricChartSeries s in series){ 
        if (s.datas.isNotEmpty){
          empty = false;
        }
      } 
      return empty;
  }
  setThreshold(double val){
    threshold = val;
    setState(() {
      
    });
  }
  _buildSeries() { 
    List<ChartSeries<dynamic, dynamic>> chartSeriesList = [];
    if (threshold != null && !empty) {  
      chartSeriesList.add(LineSeries<ChartData, DateTime>(
        name: 'Threshold',
        color: widget.thresholdColor ?? Colors.red.withOpacity(0.5),
        dataSource: <ChartData>[
          ThresholdData(
            dateTime: minX?? DateTime.now(),
            yVal: (threshold ?? 0),
          ), // Line 1
          ThresholdData(
            dateTime: maxX?? DateTime.now(),
            yVal: (threshold?? 0),
          ), // Line 3
        ],
        xValueMapper: (ChartData data, _) => data.getTimeStamp(),
        yValueMapper: (ChartData data, _) =>
            data.getVal(ChartDataType.CPUSytem),
        xAxisName: 'X', // X-axis label
        yAxisName: 'Y', // Y-axis label
      ));
    }
    series.forEach((metricSeries) {  
      if (metricSeries.type == MetricChartType.area) {
        chartSeriesList.add(AreaSeries<ChartData, DateTime>(
          name: metricSeries.name,
          color: metricSeries.color?.withOpacity(0.2) ?? Colors.transparent,
          borderColor: metricSeries.color ?? Colors.black,
          borderWidth: 1,
          dataSource: metricSeries.datas,
          xValueMapper: (ChartData data, _) => data.getTimeStamp(),
          yValueMapper: (ChartData data, _) =>
              data.getVal(metricSeries.dataType),
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
        ));
      } else if (metricSeries.type == MetricChartType.line) {
        chartSeriesList.add(LineSeries<ChartData, DateTime>(
          name: metricSeries.name,
          //system 
          animationDuration: 1,
          color: metricSeries.color?.withOpacity(0.7) ?? Colors.transparent,
          dataSource: metricSeries.datas, //
          xValueMapper: (ChartData _data, _) => _data.getTimeStamp(),
          yValueMapper: (ChartData _data, _) =>
              _data.getVal(metricSeries.dataType),
        ));
      }
      // You can add more else-if conditions for other series types
    });
    return chartSeriesList;
  }
  _checkXBounds(){  
    bool first = true; 
    for(MetricChartSeries s in series){
      for(ChartData d in s.datas){
        if(first){
          maxX = d.getTimeStamp();
          minX = d.getTimeStamp();
          first = false;
        } 
        if(d.getTimeStamp().isAfter(maxX!) ){
          maxX = d.getTimeStamp();
        }
        if(d.getTimeStamp().isBefore(minX!)){
          minX = d.getTimeStamp();
        } 
      }
    } 
    
  }
  addSeries(MetricChartSeries s) { 
    series.add(s);
    if (mounted) {
      setState(() {});
    }
  } 
}

enum MetricChartType { line, area }

class MetricChartSeries {
  String name;
  MetricChartType type;
  List<ChartData> datas;
  ChartDataType dataType;
  Color? color;

  MetricChartSeries(
      {required this.name,
      required this.type,
      required this.datas,
      required this.dataType,
      this.color}) {
    color = color ?? Colors.black;
  }
}


/*
[
      AreaSeries<ChartData, DateTime>(
          color: widget.color1.withOpacity(0.2),
          borderColor: widget.color1,
          borderWidth: 1,
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.getTimeStamp(),
          yValueMapper: (ChartData data, _) => data.getVal(),
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero)),
      LineSeries<LineData, DateTime>(
        color: widget.color2.withOpacity(0.4),
        dataSource: <LineData>[
          LineData(
            x: data[0].getTimeStamp(),
            y: 50,
          ), // Line 1
          LineData(
            x: data.last.getTimeStamp(),
            y: 50,
          ), // Line 3
        ],
        xValueMapper: (LineData data, _) => data.x,
        yValueMapper: (LineData data, _) => data.y,
        xAxisName: 'X', // X-axis label
        yAxisName: 'Y', // Y-axis label
      ),
    ]
*/