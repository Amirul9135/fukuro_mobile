import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_editor_controller.dart';
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/Controller/node_config.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/expandable_fab.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/fukuro_form.dart';

class NodeConfigForm extends StatefulWidget {
  @override
  NodeConfigFormState createState() => NodeConfigFormState();
  NodeConfigForm(
      {Key? key,
      required this.metricLabel,
      required this.thresholdUnit,
      required this.config,
      required this.node})
      : super(key: key);
  Node node;
  String metricLabel;
  String thresholdUnit;
  Map<String, dynamic> config;
}

class NodeConfigFormState extends State<NodeConfigForm> {
  // Add your state variables and methods here
  final Map<String, Map<String, dynamic>> intervalFields = {};
  final Map<String, Map<String, dynamic>> alertFields = {};
  final Map<String, Map<String, dynamic>> thresholdField = {};

  @override
  void initState() {
    // Initialize your state here
    super.initState();

    intervalFields['extract'] = FukuroFormFieldBuilder(
            fieldName: 'Extraction',
            prefix: 'Extraction',
            rightAllign: true,
            type: FukuroForm.inputNumerical,
            isTimeUnit: true)
        .build();

    intervalFields['realtime'] = FukuroFormFieldBuilder(
            fieldName: 'Realtime',
            prefix: 'Realtime',
            rightAllign: true,
            type: FukuroForm.inputNumerical,
            isTimeUnit: true)
        .build();

    alertFields['tick'] = FukuroFormFieldBuilder(
            fieldName: 'Ticks',
            prefix: 'Ticks',
            rightAllign: true,
            type: FukuroForm.inputNumerical)
        .build();

    alertFields['cooldown'] = FukuroFormFieldBuilder(
            fieldName: 'Cooldown',
            prefix: 'Cooldown',
            rightAllign: true,
            type: FukuroForm.inputNumerical,
            isTimeUnit: true)
        .build();

    thresholdField['threshold'] = FukuroFormFieldBuilder(
            fieldName: 'Threshold',
            prefix: 'Threshold',
            rightAllign: true,
            type: FukuroForm.inputNumerical,
            suffix: widget.thresholdUnit,
            help:
                'This is your own threshold value which will trigger push up notification')
        .build();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget's UI here
    thresholdField['threshold']?['value'] = widget.config['threshold'];
    return Center(
        child: Column(
      children: [
        const Divider(),
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Row(
                  children: [
                    const Text(
                      'Monitoring Configuration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                        value: widget.config['active'] ?? false,
                        onChanged: (value) {
                          _toggleMEtric();
                        }),
                    const Text("Enable")
                  ],
                ),
              ],
            )),
        const Divider(),
        FukuroForm(fields: intervalFields), 
        FukuroForm(fields: alertFields),
        const Divider(),
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Row(
                  children: [
                    const Text(
                      'Notification Configuration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                        value:((widget.config['threshold'] ?? -1) != -1),
                        onChanged: (value) {
                  _toggleNotification();
                        }),
                    const Text("Enable")
                  ],
                ),
              ],
            )), 
        ((widget.config['threshold'] ?? -1) != -1)
            ? FukuroForm(fields: thresholdField)
            : Text(''),
    /*    ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Register',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          onPressed: () {
            save();
          },
        )*/
      ],
    ));
  }

  save() {
    widget.config['extract'] =
        intervalFields['extract']?['controller'].getValInSecond();
    widget.config['realtime'] =
        intervalFields['realtime']?['controller'].getValInSecond();
    widget.config['tick'] = alertFields['tick']?['controller'].getValueInt();
    widget.config['cooldown'] =
        alertFields['cooldown']?['controller'].getValInSecond();
    print(widget.config);
  }

  _toggleMEtric() {
    FukuroDialog msg;
    if (!(widget.config['active'] ?? false)) {
      //enable
      msg = FukuroDialog(
        title: "Enable Monitoring for this Metric",
        message:
            "Agent will extract the reading at determined interval",
        mode: FukuroDialog.INFO,
        NoBtn: true,
        BtnText: "Yes",
      );
    } else {
      msg = FukuroDialog(
        title: "Disable Monitoring for this Metric",
        message:
            "Disabling monitoring will disable extraction including alert and notification triggering",
        mode: FukuroDialog.WARNING,
        NoBtn: true,
        BtnText: "Yes",
      );
    }
    showDialog(context: context, builder: (_) => msg).then((value) async {
      if (msg.okpressed) {
        if( widget.config['active'] == true ){// act to disable
          FukuroResponse res = await NodeConfig.enableMonitoring(widget.node.getNodeId(), widget.metricLabel);
          if(mounted){

          if(res.status() == 200){
            FukuroDialog.success(context, '', '');
            widget.config['active'] = !(widget.config['active'] ?? false);
          }
          else{
            FukuroDialog.error(context, 'Failed', res.body()['message']);
          }
          }
        }
        else{
          FukuroResponse res = await NodeConfig.disableMonitoring(widget.node.getNodeId(), widget.metricLabel);
          if(mounted){

          if(res.status() == 200){
            FukuroDialog.success(context, '', '');
            widget.config['active'] = !(widget.config['active'] ?? false);
          }
          else{
            FukuroDialog.error(context, 'Failed', res.body()['message']);
          }
          }
        }
       // widget.config['active'] = !(widget.config['active'] ?? false);
        setState(() {});
      }
    });
  }

  _toggleNotification() {
    FukuroDialog msg;
    if ((widget.config['threshold'] ?? -1) == -1) {
      // disable to enable
      msg = FukuroDialog(
        title: "Enable Notification",
        message:
            "FUKURO will send notification to you if this metric reading reaches your defined threshold",
        mode: FukuroDialog.INFO,
        NoBtn: true,
        textInput: true,
        BtnText: "Yes",
      );
    } else {
      msg = FukuroDialog(
        title: "Disable Notification",
        message:
            "FUKURO will not send notification to you for this metric. This is your own configuration and will not affect others.",
        mode: FukuroDialog.WARNING,
        NoBtn: true,
        BtnText: "Yes",
      );
    }

    showDialog(context: context, builder: (_) => msg).then((value) async {
      if (msg.okpressed) {
        if ((widget.config['threshold'] ?? -1) == -1) {
          double val = double.tryParse(msg.getInputText()) ?? 0;
          FukuroResponse res = await NodeConfig.enableNotification(
              widget.node.getNodeId(), widget.metricLabel, val);
          if (mounted) {
            if (res.status() == 200) {
              FukuroDialog.success(context, '', '');
              widget.config['threshold'] = val;
              thresholdField['threshold']?['value'] = val;
              thresholdField['threshold']?['refresh'] = true;
              setState(() {});
            } else {
              FukuroDialog.error(context, "Failed to Enable Notification",
                  res.body()['message']);
            }
          }
        } else {
          FukuroResponse res = await NodeConfig.disableNotification(
              widget.node.getNodeId(), widget.metricLabel);
          if (mounted) {
            if (res.status() == 200) {
              FukuroDialog.success(context, '', '');
              widget.config['threshold'] = -1;
              setState(() {});
            } else {
              FukuroDialog.error(context, "Failed to Disable Notification",
                  res.body()['message']);
            }
          }
        }
        //widget.config['threshold'] =
        // ((widget.config['threshold'] ?? -1) == -1) ? 0 : -1;
        setState(() {});
      }
    });
  }
}
