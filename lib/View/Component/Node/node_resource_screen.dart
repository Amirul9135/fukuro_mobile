import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/cpu_local_config.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/Node/node_history.dart';
import 'package:fukuro_mobile/View/Component/Node/node_monitoring.dart';
import 'package:fukuro_mobile/View/Component/Node/node_resource_config.dart';

class NodeResourceScreen extends StatefulWidget {
  const NodeResourceScreen({Key? key, required this.thisNode})
      : super(key: key);
  final Node thisNode;
  @override
  NodeScreenState createState() => NodeScreenState();
}

class NodeScreenState extends State<NodeResourceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final CPULocalConfig cpuConfig = CPULocalConfig();
  final GlobalKey<NodeResourceConfigState> configStateKey =
      GlobalKey<NodeResourceConfigState>();
  bool configLoaded = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChange);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('sni');
      await cpuConfig.load();
      print(cpuConfig.values);
      setState(() {
        configLoaded = true;
      });
    });
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
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  (configLoaded)
                      ? NodeResourceConfig(
                          key: configStateKey,
                          values: cpuConfig.values,
                        )
                      : const Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              'Loading config....',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                  NodeHistory(
                    thisnode: widget.thisNode,
                    config: cpuConfig,
                  ),
                  NodeMonitoring(
                    thisnode: widget.thisNode,
                    parentController: _tabController,
                    fallback: 0,
                    config: cpuConfig,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: (_tabController.index == 0)
            ? FloatingActionButton.extended(
                onPressed: () async {
                  // Action to perform when the button is pressed
                  bool valid = configStateKey.currentState?.validate() ?? false;
                  if (valid) {
                    await cpuConfig
                        .save(configStateKey.currentState?.saveSetting() ?? {});
                    if (mounted) {
                      showDialog(
                          context: context,
                          builder: (_) => FukuroDialog(
                              title: 'Saved',
                              message: 'Settings saved',
                              mode: FukuroDialog.SUCCESS));
                    }
                  } else {
                    if (mounted) {
                      showDialog(
                          context: context,
                          builder: (_) => FukuroDialog(
                              title: 'Error',
                              message: 'Unable to save',
                              mode: FukuroDialog.ERROR));
                    }
                  }
                },

                label: const Text('Save Setting'),
                icon: const Icon(Icons.save),
                hoverColor: Colors.blue, // Optional: Change the hover color
                hoverElevation: 10, // Optional: Adjust the elevation on hover
              )
            : null,
      ),
    );
  }

  _onTabChange() {
    print("change");
    setState(() {});
  }
}

const _tabs = [
  Tab(icon: Icon(Icons.settings), text: "Config"),
  Tab(icon: Icon(Icons.auto_graph_outlined), text: "Historical"),
  Tab(icon: Icon(Icons.monitor_heart_rounded), text: "RealTime"),
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
