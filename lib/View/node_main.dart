import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Node/node_details.dart';
import 'package:fukuro_mobile/View/Component/Node/node_resource_screen.dart';

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
                child: Text(
                  widget.thisNode.getName(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ), 
              ListTile(
                leading: const Icon(Icons.connected_tv_outlined),
                title: const Text('Node'),
                onTap: () => _selectMenuItem('Node'),
                selected: _selectedMenuItem == 'Node',
              ), 
              const Divider(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(
                  'Resources',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.data_usage_outlined),
                title: const Text('CPU'),
                onTap: () => _selectMenuItem('Res_CPU'),
                selected: _selectedMenuItem == 'Res_CPU',
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading:const Icon(Icons.exit_to_app),
                title: const Text('Back to Home'),
                onTap: () => {
            Navigator.pushNamed(context, '/home', arguments: 1)
            },
              ),
              // Add more ListTile widgets for additional menu items
            ],
          ),
        ),
        body: _selectedMenuItem == 'Node' ?  NodeDetails(node: widget.thisNode)
            : _selectedMenuItem == 'Settings' ? Text('setting')
            : _selectedMenuItem == 'Res_CPU' ? NodeResourceScreen(thisNode: widget.thisNode)
                : Text("placeholder"));
  }
}
