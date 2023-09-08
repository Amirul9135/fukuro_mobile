import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Node/config/node_config_screen.dart';
import 'package:fukuro_mobile/View/Component/Node/node_details.dart';
import 'package:fukuro_mobile/View/Component/Node/realtime/node_realtime_screen.dart';
import 'package:fukuro_mobile/View/Component/Node/report/metric_report_screen.dart';

class NodeMainScreen extends StatefulWidget {
  const NodeMainScreen({Key? key, required this.thisNode}) : super(key: key);
  final Node thisNode;

  @override
  NodeMainScreenState createState() => NodeMainScreenState();
}

class NodeMainScreenState extends State<NodeMainScreen> {
  String _selectedMenuItem = 'Node';

  void _selectMenuItem(String title) {
    setState(() {
      _selectedMenuItem = title;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    print(widget.thisNode.getNodeId());
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.thisNode.getName()),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.thisNode.getName(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      verticalGap(20),
                      Text(
                        widget.thisNode.getDescription(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )),
              ListTile(
                leading: const Icon(Icons.connected_tv_outlined),
                title: const Text('Node Details'),
                onTap: () => _selectMenuItem('Node'),
                selected: _selectedMenuItem == 'Node',
              ),
              const Divider(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(
                  'Metrics',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.monitor_heart_outlined),
                title: const Text('Connect Realtime'),
                onTap: () => _selectMenuItem('realtime'),
                selected: _selectedMenuItem == 'realtime',
              ),
              ListTile(
                leading: const Icon(Icons.auto_graph_outlined),
                title: const Text('Reports'),
                onTap: () => _selectMenuItem('Reports'),
                selected: _selectedMenuItem == 'Reports',
              ),
              const Divider(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(
                  'Configurations',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.display_settings_outlined),
                title: const Text('Configuration'),
                onTap: () => _selectMenuItem('Node_Config'),
                selected: _selectedMenuItem == 'Node_Config',
              ),
              ListTile(
                leading: const Icon(Icons.supervised_user_circle_outlined),
                title: const Text('Collaboration'),
                onTap: () => _selectMenuItem('Collaboration'),
                selected: _selectedMenuItem == 'Collaboration',
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Back to Home'),
                onTap: () =>
                    {Navigator.pushNamed(context, '/home', arguments: 1)},
              ),
            ],
          ),
        ),
        body: _selectedMenuItem == 'Node'
            ? NodeDetails(node: widget.thisNode)
            : _selectedMenuItem == 'Settings'
                ? Text('setting')
                : _selectedMenuItem == 'Node_Config'
                    ? NodeConfigScreen(
                        node: widget.thisNode,
                      )
                    : _selectedMenuItem == 'Reports'
                        ? MetricReportScreen(node: widget.thisNode)
                        : _selectedMenuItem == 'realtime'
                            ? NodeRealtimeScreen(node: widget.thisNode)
                            : Text("placeholder"));
  }
}
