import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/Controller/node_config.dart';
import 'package:fukuro_mobile/Controller/utilities.dart'; 
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/expandable_fab.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/Node/config/node_config_form.dart';
import 'package:sizer/sizer.dart';

class DISKConfiguration extends StatefulWidget {
  static String label = 'disk';
  DISKConfiguration({Key? key, required this.node}) : super(key: key);
  final Node node;

  @override
  DISKConfigurationState createState() => DISKConfigurationState();
}

class DISKConfigurationState extends State<DISKConfiguration> {
  bool loading = true;
  final  Map<String, dynamic> config = {};
  final GlobalKey<NodeConfigFormState> formStateKey = GlobalKey();
  NodeConfigForm form = NodeConfigForm(config:{},node: Node(),metricLabel: 'disk',thresholdUnit: 'disk',);

  @override
  void initState() {
    super.initState();
    _initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
  });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(),
            Text(
              'Loading Disk Configurations',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 5.h),
            child: SingleChildScrollView(
                child: Column(children: [ 
              form, 
            ]))),
        floatingActionButton: ExpandableFab(
          icon: const Icon(Icons.ads_click),
          distance: 60,
          children: [
            ActionButton(
              onPressed: () {
                _save();
              },
              icon: const Icon(Icons.save),
            ),
            ActionButton(
              onPressed: () {
                _reset();
              },
              icon: const Icon(Icons.settings_backup_restore),
            ),
          ],
        ),
      );
    }
  }
  _reset(){
    FukuroDialog msg =  FukuroDialog(
        title: "RESET",
        message:
            "Revert unsaved values and load last setting?",
        mode: FukuroDialog.WARNING,
        NoBtn: true,
        BtnText: "Yes",
      );
      
    showDialog(context: context, builder: (_) => msg).then((value) async {
      if(msg.okpressed){
        _initialize();
      }
    });
  }
  _initialize(){
    
    print('init ni');
    config['extract'] = {};
    config['realtime'] = {};
    config['tick'] = {};
    config['cooldown'] = {};
    config['active'] = {};
    config['threshold'] = {};
    _loadConfig();
    form = NodeConfigForm(key: formStateKey, config:config,node: widget.node,metricLabel: 'disk',thresholdUnit: '%(utilization)',thresholdMax: 100,);
  }
  _save() async {  
    print('save');
    try{
      
    formStateKey.currentState?.save();
    dynamic payload = {};
    payload['extract'] = config['extract']['value'];
    payload['realtime'] = config['realtime']['value'];
    payload['tick'] = config['tick']['value'];
    payload['cooldown'] = config['cooldown']['value'];
    payload['threshold'] = config['threshold']['value']; 
    print(payload) ; 
    FukuroResponse res = await NodeConfig.updateMetricConfigValues(widget.node.getNodeId(), DISKConfiguration.label, payload);
    if(res.ok()){
      if(mounted){
        if( payload['threshold'] != 0){
          FukuroResponse res2 = await NodeConfig.enableNotification(widget.node.getNodeId(), DISKConfiguration.label, payload['threshold']);
          if(!res2.ok()){
            if(mounted){
              String msg = res2.msg();
              FukuroDialog.error(context, 'Failed', 'Unable to save notification $msg');
            }
            
              return;
          }
        }
        if(mounted){ 
          FukuroDialog.success(context, 'Saved', '');
        }
        _initialize();
      }
    }
    else{
      if(mounted){
        FukuroDialog.error(context, 'Failed to Save', res.msg());
      }

    }
    }
    catch(e){
      print('error $e');
    }
    setState(() {
      
    });
  }
  _loadConfig() async {
    
    loading = true;
    setState(() {
      
    });
    try {
      FukuroResponse res = await NodeConfig.loadMetricConfigurations(
          widget.node.getNodeId(), DISKConfiguration.label);
      if (mounted) {
        if (res.ok()) {
          try{ 
        //    print(config);
           //   print(res.body());
            config['extract']['value'] = res.body()['extract'];
            config['realtime']['value'] = res.body()['realtime'];
            config['tick']['value'] = res.body()['tick'];
            config['cooldown']['value'] = res.body()['cooldown'];
            config['active'] = res.body()['active']??false;
            config['threshold']['value'] = res.body()['threshold'];
            if(config['threshold']['value'] == false){
              config['threshold']['value'] = 0;
            }
            config['extract']['refresh'] = true;
            config['realtime']['refresh'] = true;
            config['tick']['refresh'] =true;
            config['cooldown']['refresh'] = true; 
            config['threshold']['refresh'] = true;
          }
          catch(e){
            print('error $e');
          }
          loading = false;
          setState(() {});
        } else {
          FukuroDialog.error(context, 'Failed', 'Unable to load disk config');
          _loadConfig();
          return;
        }
      } 
    } catch (e) {}
  }
}
