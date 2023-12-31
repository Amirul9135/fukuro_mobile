import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/Authentication.dart';
import 'package:fukuro_mobile/View/Component/Misc/expandable_fab.dart';
import 'package:fukuro_mobile/View/Component/Node/node_list.dart';
import 'package:fukuro_mobile/View/Component/notification_screen.dart';
import 'package:fukuro_mobile/View/profile.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.lightBlue,
              expandedHeight: 350.0,
              
              floating: true,
              pinned: true,
              snap: false,
              automaticallyImplyLeading: false,
              
              flexibleSpace: FlexibleSpaceBar( 
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                title:const Text("HOME"),
                 background: Image.asset(
                     'assets/fukuro name wbg.png',
                     fit: BoxFit.fill,
                  )

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
                  NodeList(),
                  NotificationScreen(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: (_tabController.index == 0)
            ? ExpandableFab(
                icon: const Icon(Icons.settings),
                distance: 100,
                children: [
                  ActionButton(
                    onPressed: () async {
                      isLoggingOut = true;
                      setState(() {});
                      await Authentication.logOut();

                      Navigator.pushNamed(context, '/');
                    },
                    icon: const Icon(Icons.logout),
                  ),
                  ActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      );
                    },
                    icon: const Icon(Icons.person),
                  ),
                  ActionButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/node/register', (route) => false);
                    },
                    icon: const Icon(Icons.add_outlined),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  _onTabChange() {
    print("change");
    if (mounted) setState(() {});
  }
}

const _tabs = [
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
