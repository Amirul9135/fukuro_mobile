import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/big_button.dart';
import 'package:fukuro_mobile/View/Component/Misc/expandable_fab.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/Misc/metric_select.dart';
import 'package:fukuro_mobile/View/Component/Node/report/cpu_report.dart';
import 'package:fukuro_mobile/View/Component/Node/report/disk_report.dart';
import 'package:fukuro_mobile/View/Component/Node/report/mem_report.dart';
import 'package:fukuro_mobile/View/Component/Node/report/net_report.dart';
import 'package:sizer/sizer.dart';

class MetricReportScreen extends StatefulWidget {
  final Node node;

  const MetricReportScreen({
    Key? key,
    required this.node,
  }) : super(key: key);

  @override
  MetricReportScreenState createState() => MetricReportScreenState();
}

class MetricReportScreenState extends State<MetricReportScreen> {
  final List<Widget> reports = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
        child: SingleChildScrollView(
          child: Column(
            children: reports.map((report) {
              return Container(
                margin:
                    const EdgeInsets.only(bottom: 15.0), // Set the margin here
                child: report,
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: ExpandableFab(
        icon: const Icon(Icons.ads_click),
        distance: 60,
        children: [
          ActionButton(
            onPressed: () {
              _selectMetric();
            },
            icon: const Icon(Icons.add_rounded),
          ),
          ActionButton(
            onPressed: () {
              _clearAll();
            },
            icon: const Icon(Icons.clear_rounded),
          ),
        ],
      ),
    );
  }

  _delete(target) {
    print('dete $target');
    reports.remove(target);
    if (mounted) {
      setState(() {});
    }
  }

  _clearAll() {
    if(reports.isNotEmpty){
    FukuroDialog msg = FukuroDialog(
      title: "Clear All Report",
      message:
          "Clear all reports?",
      mode: FukuroDialog.QUESTION,
      NoBtn: true, 
      BtnText: "Yes",
    );
    showDialog(context: context, builder: (_) => msg).then((value) {
      if(msg.okpressed){
        reports.clear();
        if(mounted){
          setState(() {
            
          });
        }
      }
    });

    }
  }

  _addReport(Metrics selected) {
    Navigator.of(context).pop();
    print('add $selected');
    if (selected == Metrics.cpu) {
      reports.add(CPUReport(
        node: widget.node,
        fnDelete: _delete,
      ));
    } else if (selected == Metrics.memory) {
      reports.add(MEMReport(
        node: widget.node,
        fnDelete: _delete,
      ));
    } else if(selected == Metrics.network){
      reports.add(NETReport(
        node: widget.node,
        fnDelete: _delete,
      ));

    } else if(selected == Metrics.disk){
      reports.add(DISKReport(
        node: widget.node,
        fnDelete: _delete,
      ));

    }
    if (mounted) {
      setState(() {});
    }
  }

  _selectMetric() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MetricSelect(selectMetric: _addReport);
      },
    );
  }
}
