import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/fukuro_request.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Monitoring/node_history.dart';
import 'package:fukuro_mobile/View/Component/Monitoring/node_monitoring.dart';

import '../../../Controller/node_controller.dart';
import '../Misc/fukuro_dialog.dart';

class NodeScreen extends StatefulWidget {
  const NodeScreen({Key? key, required this.thisNode}) : super(key: key);
  final Node thisNode;
  @override
  NodeScreenState createState() => NodeScreenState();
}

class NodeScreenState extends State<NodeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              floating: true,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                title: Text(
                  widget.thisNode.getName(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
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
              floating: true,
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  NodeHistory(
                    thisnode: widget.thisNode,
                  ),
                  NodeMonitoring(
                    thisnode: widget.thisNode,
                  ),
                  Text("Command"),
                  Text("Config"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool verfiyTab = false;
  _onTabChange() {
    print("change");
    setState(() {});
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 1 && !verfiyTab) {
        int index = _tabController.index;
        _tabController.index = _tabController.previousIndex;
        FukuroDialog wsConf = FukuroDialog(
          title: "Activating Live Connection",
          message: "Please Insert Passkey",
          mode: FukuroDialog.WARNING,
          NoBtn: true,
          BtnText: "Proceed",
          textInput: true,
        );
        showDialog(context: context, builder: (_) => wsConf)
            .then((value) async {
          if (wsConf.okpressed) {
              widget.thisNode.setPassKey(wsConf.getInputText());
            if (await checkAccessToNode(widget.thisNode)) {
              verfiyTab = true;
              _tabController.animateTo(index);
            } else {
              if(mounted){
              showDialog(
                  context: context,
                  builder: (_) => FukuroDialog(
                        title: "No Access",
                        message: "Please Check your pass key and retry",
                        mode: FukuroDialog.ERROR, 
                      ));
              }
            }
          }
        });
      }
    } else {
      if (_tabController.index != 1) {
        verfiyTab = false;
      }
    }
  }
}

const _tabs = [
  Tab(icon: Icon(Icons.auto_graph_outlined), text: "Historical"),
  Tab(icon: Icon(Icons.monitor_heart_rounded), text: "RealTime"),
  Tab(icon: Icon(Icons.connected_tv_outlined), text: "Command"),
  Tab(icon: Icon(Icons.settings), text: "Config"),
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
