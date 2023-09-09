import 'package:flutter/material.dart'; 
import 'package:fukuro_mobile/View/Component/Node/node_list.dart';
import 'package:fukuro_mobile/View/Component/Misc/expandable_fab.dart';
import 'package:fukuro_mobile/Controller/Authentication.dart';
import 'package:fukuro_mobile/View/Component/notification_screen.dart';

class Home extends StatefulWidget {
  Home({Key? key, this.tabIndex = 0}) : super(key: key);
  final int tabIndex;

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoggingOut = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChange);
    int initIndex = (_tabController.length - 1 < widget.tabIndex)
        ? _tabController.length - 1
        : widget.tabIndex;
    _tabController.animateTo(initIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggingOut) {
      return Container(
        color: Colors.grey.shade600.withOpacity(.5),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                  height:
                      16), // Adjust the space between the indicator and text
             
            ],
          ),
        ),
      );
    }

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
                  Text("staging debug"),
                  NodeList(),
                  NotificationScreen(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: (_tabController.index == 1)
            ? FloatingActionButton(
                child: Icon(Icons.add_outlined),
                onPressed: () {
                  // Action to perform when the button is pressed
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/node/register', (route) => false);
                },

                hoverColor: Colors.blue, // Optional: Change the hover color
                hoverElevation: 10, // Optional: Adjust the elevation on hover
              )
            : ExpandableFab(
                icon: const Icon(Icons.settings),
                distance: 100,
                children: [
                  ActionButton(
                    onPressed: () async {
                      isLoggingOut = true;
                      setState(() {});
                      await Authentication.logOut();

                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    icon: const Icon(Icons.logout),
                  ),
                  ActionButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/setting', (route) => false);
                    },
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
    if (mounted) setState(() {});
  }
}

const _tabs = [
  Tab(icon: Icon(Icons.dashboard_rounded), text: "Dashboard"),
  Tab(icon: Icon(Icons.monitor_heart_rounded), text: "Nodes"),
  Tab(icon: Icon(Icons.circle_notifications), text: "Notifications"),
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
