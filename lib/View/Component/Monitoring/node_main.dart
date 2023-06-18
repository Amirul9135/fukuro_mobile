import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Monitoring/node_monitoring.dart';

class NodeScreen extends StatefulWidget {
 
  const NodeScreen({Key? key, required this.thisNode}) : super(key: key);
  final Node thisNode;
  
  @override
  NodeScreenState createState() => NodeScreenState();
}

class NodeScreenState extends State<NodeScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChange);
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
     return DefaultTabController(
    length: 3,
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
            child: 
            
            TabBarView(
              controller: _tabController,
              children: const [
                NodeMonitoring(),
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

  
 
  _onTabChange() {
    print("change");
    setState(() {});
  }
}



const _tabs = [ 
  Tab(icon: Icon(Icons.monitor_heart_rounded), text: "Monitoring"),
  Tab(icon: Icon(Icons.connected_tv_outlined), text: "Command"),
  Tab(icon: Icon(Icons.settings), text: "Configuration"),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  //_SliverAppBarDelegate(this._tabBar,this.vsync);

  _SliverAppBarDelegate({required this.tabBar, required this.vsync}):super();

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
    return  Container(
      color: Colors.white, // ADD THE COLOR YOU WANT AS BACKGROUND.
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}