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
  bool ready = false;

  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
     WidgetsBinding.instance
        .addPostFrameCallback((_) async {  
          _nodes.clear(); 
          _nodes.addAll(await NodeController.fetchAllUserOwnedNodes());
          ready = true;
          //loadData();
          setState(() {
            
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    // Build your widget UI here
    if(_nodes.isEmpty  ){
      if(!ready){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      else{
        return const Center(
          child: Text("No Node registered"),
        );

      }
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
 
}
