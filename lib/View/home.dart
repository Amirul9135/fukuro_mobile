import 'package:flutter/material.dart'; 
import 'package:fukuro_mobile/View/Component/Monitoring/node_list.dart';
import 'package:fukuro_mobile/View/Component/Misc/expandable_fab.dart';
import 'package:fukuro_mobile/Controller/Authentication.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
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
          const SliverAppBar(
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            snap: false,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              title: Text(
                "FUKURO",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            
            delegate: _SliverAppBarDelegate(
              
              tabBar:  TabBar(
                
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
              children: const [
                Text("dashboard"),
                NodeList(),
                Text("notification"),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        icon: const Icon(Icons.settings),
        distance: 100,
        children: [
          ActionButton(
            onPressed: () async {
              await logOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
          ActionButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
          ActionButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
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
  Tab(icon: Icon(Icons.dashboard_rounded), text: "Dashboard"),
  Tab(icon: Icon(Icons.monitor_heart_rounded), text: "Monitoring"),
  Tab(icon: Icon(Icons.circle_notifications), text: "Notifications"),
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
