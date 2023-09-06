import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Node/config/cpu_config.dart';
import 'package:fukuro_mobile/View/Component/Node/config/disk_config.dart';
import 'package:fukuro_mobile/View/Component/Node/config/mem_config.dart';
import 'package:fukuro_mobile/View/Component/Node/config/net_config.dart';
import 'package:fukuro_mobile/View/Component/Node/config/node_config_form.dart';

class NodeConfigScreen extends StatefulWidget {
  const NodeConfigScreen({Key? key, required this.node}) : super(key: key);
  final Node node;
  @override
  NodeConfigScreenState createState() => NodeConfigScreenState();
}

class NodeConfigScreenState extends State<NodeConfigScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabChange);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
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
                  children: [Text('1'),
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
}

const _tabs = [
  Tab(icon: Icon(Icons.settings), text: "Main"),
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
