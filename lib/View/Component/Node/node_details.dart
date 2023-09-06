 

import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/node_form.dart';
import 'package:sizer/sizer.dart';

import '../../../Controller/utilities.dart';

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
            onExpansionChanged: expansionChange,
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
        ])));
  }

  expansionChange(isExpand) {
    if (isExpand) {
      setState(() {});
    }
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

  @override
  void dispose() {
    // Clean up resources and listeners here
    super.dispose();
  }
}
