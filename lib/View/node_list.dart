import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Node/node_item.dart';

class NodeList extends StatefulWidget {
  const NodeList({Key? key}) : super(key: key);
  @override
  NodeListState createState() => NodeListState();
}

class NodeListState extends State<NodeList> {
  // Define your state variables here
  final List<Node> _nodes = [];

  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
     WidgetsBinding.instance
        .addPostFrameCallback((_) async {  
          _nodes.clear();
          _nodes.addAll(await fetchAllUserOwnedNodes());
          //loadData();
          setState(() {
            
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    // Build your widget UI here
    if(_nodes.isEmpty){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const  EdgeInsets.all(10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    border: Border.all(
                      color: Colors.lightBlue,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:  const EdgeInsets.all(15.0),
                  margin:  const EdgeInsets.symmetric(vertical: 5),
                  child: NodeItem(node:_nodes[index]),
                );
              },
              childCount: _nodes.length,
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // Clean up resources or subscriptions here
    super.dispose();
  } 

/*ddummy
  void loadData() {
    Node test1 = Node();
    test1.setName("test1");
    test1.setIpAddress("test11111");
    test1.setDescription("descdsdsadsadddddddddddddddddddddddddddddddddddddsadassssssssssssssssssssssssssssssssdasdsadasdasdadadasssssssssssssssssssssssssssssssssssssssssss");
    Node tests = Node();
    tests.setName("test2");
    tests.setIpAddress("2222");
    tests.setDescription("desc");

    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
    _nodes.add(test1);
    _nodes.add(tests);
  }*/
}
