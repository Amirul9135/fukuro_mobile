 
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/View/Component/Misc/big_button.dart';

class MetricSelect extends StatelessWidget {
  MetricSelect(
      {super.key,
      required this.selectMetric,
      this.toggleMode,
      this.buttonsData}) {
    buttonsData ??= [
      {
        'icon': Icons.memory,
        'label': 'CPU',
        'value': Metrics.cpu,
        'toggle': false
      },
      {
        'icon': Icons.dashboard,
        'label': 'Memory',
        'value': Metrics.memory,
        'toggle': false
      },
      {
        'icon': Icons.layers,
        'label': 'Disk',
        'value': Metrics.disk,
        'toggle': false
      },
      {
        'icon': Icons.network_check,
        'label': 'Network',
        'value': Metrics.network,
        'toggle': false
      },
    ];
  }
  final bool? toggleMode;
  final Function(Metrics) selectMetric;

  List<Map<String, dynamic>>? buttonsData;

  List<Map<String, dynamic>> data() {
    return buttonsData!;
  }

  @override
  Widget build(BuildContext context) {
    print(buttonsData);
    return Container(
      padding: const EdgeInsets.all(50),
      alignment: Alignment.center,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
        ),
        itemCount: buttonsData!.length,
        itemBuilder: (BuildContext context, int index) {
          Color? c;
          if (toggleMode == true && buttonsData![index]['toggle'] == false) {
            c = Colors.grey.shade500;
          }
          BigButton btn = BigButton(
            icon: buttonsData![index]['icon'],
            label: buttonsData![index]['label'],
            value: buttonsData![index]['value'],
            action: selectMetric,
            color: c,
          );
          return btn;
        },
      ),
    );
  }
}
