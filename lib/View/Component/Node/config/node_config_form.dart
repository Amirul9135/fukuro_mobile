import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/Controller/node_config.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/node.dart';
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
      required this.node,
      this.thresholdMax})
      : super(key: key);
  final Node node;
  final String metricLabel;
  final String thresholdUnit;
  final dynamic thresholdMax;
  final Map<String, dynamic> config;
}

class NodeConfigFormState extends State<NodeConfigForm> {
  // Add your state variables and methods here
  final Map<String, Map<dynamic, dynamic>> intervalFields = {};
  final Map<String, Map<dynamic, dynamic>> alertFields = {};
  final Map<String, Map<dynamic, dynamic>> thresholdField = {};

  @override
  void initState() {
    // Initialize your state here
    super.initState();
    intervalFields['extract'] = widget.config['extract'];
    intervalFields['extract']?.addAll(FukuroFormFieldBuilder(
            fieldName: 'Extraction',
            prefix: 'Extraction',
            rightAllign: true,
            type: FukuroForm.inputNumerical,
            value: widget.config['extract']['value'].toString(),
            readOnly: (widget.node.access != 1),
            isTimeUnit: true)
        .build());
    intervalFields['realtime'] = widget.config['realtime'];
    intervalFields['realtime']?.addAll(FukuroFormFieldBuilder(
            fieldName: 'Realtime',
            prefix: 'Realtime',
            rightAllign: true,
            value: widget.config['realtime']['value'].toString(),
            readOnly: (widget.node.access != 1),
            type: FukuroForm.inputNumerical,
            isTimeUnit: true)
        .build());

    alertFields['tick'] = widget.config['tick'];
    alertFields['tick']?.addAll(FukuroFormFieldBuilder(
            fieldName: 'Ticks',
            prefix: 'Ticks',
            rightAllign: true,
            value: widget.config['tick']['value'].toString(),
            readOnly: (widget.node.access != 1),
            type: FukuroForm.inputNumerical)
        .build());
    alertFields['cooldown'] = widget.config['cooldown'];
    alertFields['cooldown']?.addAll(FukuroFormFieldBuilder(
            fieldName: 'Cooldown',
            prefix: 'Cooldown',
            rightAllign: true,
            value: widget.config['cooldown']['value'].toString(),
            readOnly: (widget.node.access != 1),
            type: FukuroForm.inputNumerical,
            isTimeUnit: true)
        .build());
    thresholdField['threshold'] = widget.config['threshold'];
    thresholdField['threshold']?.addAll(FukuroFormFieldBuilder(
            fieldName: 'Threshold',
            prefix: 'Threshold',
            rightAllign: true,
            type: FukuroForm.inputNumerical,
            value: widget.config['threshold']['value'].toString(),
            suffix: widget.thresholdUnit,
            numMax: myPareseNum(widget.thresholdMax),
            help:
                'This is your own threshold value which will trigger push up notification')
        .build());
    print('aftr');
    print(widget.config);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget's UI here
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
                    (widget.node.access == 1) ?
                    Switch(
                        value: widget.config['active'] == true,
                        onChanged: (value) {
                          _toggleMEtric();
                        }):Container(),
                    (widget.node.access == 1) ?
                    const Text("Enable"):Container()
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
                        value:
                            (myPareseNum(widget.config['threshold']['value']) !=
                                0),
                        onChanged: (value) {
                          _toggleNotification();
                        }),
                    const Text("Enable")
                  ],
                ),
              ],
            )),
        (myPareseNum(widget.config['threshold']['value']) != 0)
            ? FukuroForm(fields: thresholdField)
            : Text(''),
      ],
    ));
  }

  save() {
    try {
      print('inner save ');

      widget.config['extract']['value'] =
          intervalFields['extract']?['controller'].getValInSecond();
      widget.config['realtime']['value'] =
          intervalFields['realtime']?['controller'].getValInSecond();
      widget.config['tick']['value'] =
          alertFields['tick']?['controller'].getValueInt();
      widget.config['cooldown']['value'] =
          alertFields['cooldown']?['controller'].getValInSecond();
      widget.config['cooldown']['value'] =
          alertFields['cooldown']?['controller'].getValInSecond();
      widget.config['threshold']['value'] =
          thresholdField['threshold']?['controller']?.getValueDouble() ?? 0;
    } catch (e) {
      print('inner save er $e');
    }
  }

  _toggleMEtric() {
    FukuroDialog msg;
    if (widget.config['active'] == true) {
      //enable
      msg = FukuroDialog(
        title: "Enable Monitoring for this Metric",
        message: "Agent will extract the reading at determined interval",
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
        if (widget.config['active'] == true) {
          // act to disable
          FukuroResponse res = await NodeConfig.enableMonitoring(
              widget.node.getNodeId(), widget.metricLabel);
          if (mounted) {
            if (res.status() == 200) {
              FukuroDialog.success(context, '', '');
              widget.config['active'] = !(widget.config['active'] ?? false);
            } else {
              FukuroDialog.error(context, 'Failed', res.body()['message']);
            }
          }
        } else {
          FukuroResponse res = await NodeConfig.disableMonitoring(
              widget.node.getNodeId(), widget.metricLabel);
          if (mounted) {
            if (res.status() == 200) {
              FukuroDialog.success(context, '', '');
              widget.config['active'] = !(widget.config['active'] ?? false);
            } else {
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
    if ((myPareseNum(widget.config['threshold']['value']) == 0)) {
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
        if ((myPareseNum(widget.config['threshold']['value']) == 0)) {
          double val = double.tryParse(msg.getInputText()) ?? 0;
          FukuroResponse res = await NodeConfig.enableNotification(
              widget.node.getNodeId(), widget.metricLabel, val);
          if (mounted) {
            if (res.status() == 200) {
              FukuroDialog.success(context, '', '');
              widget.config['threshold']['value'] = val;
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
              widget.config['threshold']['value'] = 0;
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
