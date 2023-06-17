import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/node.dart';

class NodeItem extends StatelessWidget {
  final Node node;
  const NodeItem({Key? key, required this.node}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
       
  mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.connected_tv_outlined,
          size: 80,
          color: Colors.white,
        ),
        Column( 
  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(node.getName(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25
            ),),
            Text(node.getIpAddress(),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20
            ),)
            ],
        ),
        const Spacer(),
        const Icon(
          Icons.navigate_next_outlined,
          size: 50,
          color: Colors.white,
        ),
      ],
    );
  }
}
