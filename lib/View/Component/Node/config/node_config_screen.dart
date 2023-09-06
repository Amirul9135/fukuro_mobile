import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/Controller/node_config.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/Node/config/cpu_config.dart';
import 'package:fukuro_mobile/View/Component/Node/config/disk_config.dart';
import 'package:fukuro_mobile/View/Component/Node/config/mem_config.dart';
import 'package:fukuro_mobile/View/Component/Node/config/net_config.dart'; 

class NodeConfigScreen extends StatefulWidget {
  const NodeConfigScreen({Key? key, required this.node}) : super(key: key);
  final Node node;
  @override
  NodeConfigScreenState createState() => NodeConfigScreenState();
}

class NodeConfigScreenState extends State<NodeConfigScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
   final TextEditingController txtPushInterval = TextEditingController();
  final Map<dynamic,dynamic> mainconfig = {
    "active":true,
    "interval":60
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChange);
    _initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(child: Row(children: [ 
              const Text('Monitoring Configuration',style: TextStyle(color: Colors.blue),),
              Switch(value: mainconfig['active']??true, onChanged: (value) {
                          _togglePush();
                        }),
              Spacer(),
              Expanded(child: 
              TextFormField(
                
                controller: txtPushInterval,
                keyboardType: TextInputType.number,  
                decoration:  InputDecoration(
                  prefix: const Text('Push Interval(sec):   ',style: TextStyle(color: Colors.blue)),
                  suffix: IconButton(icon: const Icon(Icons.check,color: Colors.blue,),onPressed:  (){
                    _savePush();
                  },), 
                ),
              ),), 
          ]),)
          ,backgroundColor: Colors.white ,),
          body: CustomScrollView(
            slivers: [ 
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  tabBar: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: _tabs,
                  ),
                  vsync: this,
                ),
                pinned: true,
                floating: false,
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [ 
                  CPUConfiguration(node: widget.node),
                  MEMConfiguration(node: widget.node),
                  DISKConfiguration(node: widget.node),
                  NETConfiguration(node: widget.node)],
                ),
              ),
            ],
          ),
        ));
  }

  _onTabChange() {
    print("change");
    setState(() {});
  }

  _initialize() async {
    FukuroResponse res = await NodeConfig.loadPush(widget.node.getNodeId());
    if(res.ok()){
      print('jere');
      print(res.body());
      mainconfig['active'] = res.body()['active']??false;
      mainconfig['interval'] = res.body()['interval']??60;
      
      txtPushInterval.text = (mainconfig['interval']??0).toString();
      setState(() {
        
      });

    }
    else{
      if(mounted){
        
      FukuroDialog.error(context, 'Failed to load push metric configuration', res.msg());
      }
    }
  }
  _togglePush()async {
    try{
      bool current = mainconfig['active'] == true; 
      FukuroDialog msg;
      if(current){ 
        msg = FukuroDialog(
          title: "Disable Metric Push",
          message:
              "Disabling Metric Pushing will result to no metric will be saved into the system ignoring all other configurations",
          mode: FukuroDialog.INFO,
          NoBtn: true, 
          BtnText: "Yes",
        );
      }
      else{
        msg = FukuroDialog(
          title: "Enable Metric Push",
          message:
              "Metric will be extracted as per configured and pushed to the server at the determined interval",
          mode: FukuroDialog.INFO,
          NoBtn: true, 
          BtnText: "Yes",
        );
      }
      
    showDialog(context: context, builder: (_) => msg).then((value) async {
      if(msg.okpressed){
        FukuroResponse res = await NodeConfig.togglePush(widget.node.getNodeId(), !current);
        if(res.ok()){
          if(mounted){
            
            FukuroDialog.success(context, "Saved",'');
            _initialize();
          }
        }
        else{
          if(mounted){
            FukuroDialog.error(context, "Failed", res.msg());
          }
        }
      }
    });
    }catch(e){
      print('error test $e');
    }
  }
  _savePush() async {
    double val = myPareseNum(txtPushInterval.text);
    FukuroResponse res = await NodeConfig.updatePush(widget.node.getNodeId(), val);
    if(mounted){
      
    if(res.ok()){
      FukuroDialog.success(context, 'Saved', '');
      _initialize();
    }
    else{
      FukuroDialog.error(context, 'Failed to Save', res.msg());
    }
    }

  }

}

const _tabs = [ 
  Tab(icon: Icon(Icons.memory), text: "CPU"),
  Tab(icon: Icon(Icons.dashboard), text: "RAM"),
  Tab(icon: Icon(Icons.layers), text: "Disk"),
  Tab(icon: Icon(Icons.network_check), text: "Network"),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  //_SliverAppBarDelegate(this._tabBar,this.vsync);

  _SliverAppBarDelegate({required this.tabBar, required this.vsync}) : super();

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  final TickerProvider vsync;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // ADD THE COLOR YOU WANT AS BACKGROUND.
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
 