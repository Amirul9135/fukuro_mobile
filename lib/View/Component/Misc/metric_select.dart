import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/View/Component/Misc/big_button.dart'; 

class MetricSelect extends StatelessWidget {
  MetricSelect({
    super.key,
    required this.selectMetric,
  });

  final Function(Metrics) selectMetric;

  final List<Map<String, dynamic>> buttonsData = [
    {'icon': Icons.memory, 'label': 'CPU', 'value': Metrics.cpu},
    {'icon': Icons.dashboard, 'label': 'Memory', 'value': Metrics.memory},
    {'icon': Icons.layers, 'label': 'Disk', 'value': Metrics.disk},
    {'icon': Icons.network_check, 'label': 'Network', 'value': Metrics.network},
  ];
  @override
  Widget build(BuildContext context) {
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
        itemCount: buttonsData.length,
        itemBuilder: (BuildContext context, int index) {
          return BigButton(
            icon: buttonsData[index]['icon'],
            label: buttonsData[index]['label'],
            value: buttonsData[index]['value'],
            action: selectMetric,
          );
        },
      ),
    );
  }
}
