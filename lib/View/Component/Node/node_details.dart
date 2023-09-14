import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Node/node_form.dart'; 
import 'package:sizer/sizer.dart';

class NodeDetails extends StatefulWidget {
  const NodeDetails({Key? key, required this.node}) : super(key: key);
  final Node node;
  @override
  NodeDetailsState createState() => NodeDetailsState();
}

class NodeDetailsState extends State<NodeDetails> {
  // Declare your variables and properties here
  final GlobalKey<NodeFormState> formStateKey = GlobalKey();
  NodeForm form = NodeForm();

  final GlobalKey<ExpansionTileCustomState> keyCardCredential = GlobalKey();

  final Map<String, String> specs = {};

  bool lock = true;
  @override
  void initState() {
    form = NodeForm(
      key: formStateKey,
      origin: widget.node,
      readonly: true,
      nokey: true,
      showId: true,
    );
    // Initialize your state here
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadSpec();
      setState(() {
        keyCardCredential.currentState?.expand();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build your widget tree here
    return Container(
        padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
        child: SingleChildScrollView(
            child: Column(children: [
          ExpansionTileBorderItem(
            expansionKey: keyCardCredential,
            title: const Row(
              children: [
                Icon(Icons.app_settings_alt_outlined),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Credential",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            children: [
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 0,
              ),
              verticalGap(1.h),
              form,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Change Pass Key',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      lock ? 'Edit' : 'Save',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    if (lock) {
                      toggleEdit();
                    } else {
                      saveChanges();
                      toggleEdit();
                    }
                  },
                ),
              ),
            ],
          ),
          verticalGap(20),
          ExpansionTileBorderItem(
            title: const Row(
              children: [
                Icon(Icons.display_settings_rounded),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Node Specifications",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            children: (specs.isNotEmpty) ? specs.keys.map((e) {
              return Column(
                children: [
                  Row(
                    children: [
                      Text(e),
                      const Spacer(),
                      Text(specs[e] ?? ''),
                    ],
                  ),
                  const Divider(), // Adds a horizontal line between rows
                ],
              );
            }).toList():
            [
            const   Center(child: Text("No specification data, connect agent with the server to retrieve specification data"),)
            ],
          ),
        ])));
  }

  saveChanges() {
    formStateKey.currentState?.update(widget.node.getNodeId());
  }

  toggleEdit() {
    setState(() {
      lock = !lock;
      formStateKey.currentState?.toggleLock(lock);
    });
  }

  _loadSpec() async {
    FukuroResponse res =
        await NodeController.getNodeSpec(widget.node.getNodeId());
    if (res.ok()) {
      for (var k in res.body().keys) {
        specs[k] = res.body()[k];
      }
    }
  }

  @override
  void dispose() {
    // Clean up resources and listeners here
    super.dispose();
  }
}
