import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/dsik_drive.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/disk_list.dart';
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _selectMetric();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (reports.isEmpty)
          ? const Center(
              child: Text(
                  "Use the button at the bottom right of the screen to generate report",
                  style: TextStyle(fontSize: 16),),
                  
            )
          : Container(
              padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
              child: SingleChildScrollView(
                child: Column(
                  children: reports.map((report) {
                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: 15.0), // Set the margin here
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
    if (reports.isNotEmpty) {
      FukuroDialog msg = FukuroDialog(
        title: "Clear All Report",
        message: "Clear all reports?",
        mode: FukuroDialog.QUESTION,
        NoBtn: true,
        BtnText: "Yes",
      );
      showDialog(context: context, builder: (_) => msg).then((value) {
        if (msg.okpressed) {
          reports.clear();
          if (mounted) {
            setState(() {});
          }
        }
      });
    }
  }

  _addReport(Metrics selected) async {
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
    } else if (selected == Metrics.network) {
      reports.add(NETReport(
        node: widget.node,
        fnDelete: _delete,
      ));
    } else if (selected == Metrics.disk) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(50),
              alignment: Alignment.center,
              child: DiskList(
                node: widget.node,
                fnSelect: _addDiskReport,
                title: "Select Disk",
                showMonitorStat: true,
              ));
        },
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  _addDiskReport(DiskDrive d) {
    Navigator.of(context).pop();

    reports.add(DISKReport(
      node: widget.node,
      fnDelete: _delete,
      diskName: d.name,
    ));
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
