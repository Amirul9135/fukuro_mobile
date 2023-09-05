import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';

class NodeItem extends StatelessWidget {
  final Node node;
  const NodeItem({Key? key, required this.node}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //check for access
        FukuroDialog wsConf = FukuroDialog(
          title: "Access Verification",
          message: "Please Insert Node Passkey",
          mode: FukuroDialog.WARNING,
          NoBtn: true,
          BtnText: "Proceed",
          textInput: true,
        );
        showDialog(context: context, builder: (_) => wsConf)
            .then((value) async {
          if (wsConf.okpressed) {
            node.setPassKey(wsConf.getInputText());
            if (await NodeController.checkAccessToNode(node)) { 
              Navigator.pushNamed(context, '/node', arguments: node);
            } else {
              showDialog(
                  context: context,
                  builder: (_) => FukuroDialog(
                        title: "No Access",
                        message: "Please Check your pass key and retry",
                        mode: FukuroDialog.ERROR,
                      ));
            }
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.connected_tv_outlined,
            size: 80,
            color: Colors.grey[50],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                node.getName(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 25),
              ),
              Text(
                node.getDescription(),
                style:
                    const TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
              )
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.navigate_next_outlined,
            size: 50,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
