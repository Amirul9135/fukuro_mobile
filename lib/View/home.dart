import 'package:flutter/material.dart';
import 'package:fukuro_mobile/View/Component/expandable_fab.dart';
import 'package:fukuro_mobile/Controller/Authentication.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                stretch: true,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title:  Text("FUKURO",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: _tabs,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
              children: _tabs
                  .map((e) => Center(
                        child: Text("${e.text}", textAlign: TextAlign.center),
                      ))
                  .toList()),
        ),
        floatingActionButton: ExpandableFab(
          icon: const Icon(Icons.settings),
          distance: 100,
          children: [
            ActionButton(
              onPressed: () async {
                await logOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
}

const _tabs = [
  Tab(icon: Icon(Icons.dashboard_rounded), text: "Dashboard"),
  Tab(icon: Icon(Icons.circle_notifications), text: "Notifications"),
  Tab(icon: Icon(Icons.monitor_heart_rounded), text: "Monitoring"),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
