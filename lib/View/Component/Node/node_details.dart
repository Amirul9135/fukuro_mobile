import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/node_form.dart';
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
  @override
  void initState() {
    // Initialize your state here
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    formStateKey.currentState?.loadData(widget.node);
    setState(() {
      
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build your widget tree here
    form = NodeForm(
      key: formStateKey,
    );
    return Container(
        padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
        child: SingleChildScrollView(
            child: Column(children: [
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
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                saveChanges();
              },
            ),
          ),
        ])));
  }

  saveChanges() {
    formStateKey.currentState?.update(widget.node.getNodeId());
  }

  @override
  void dispose() {
    // Clean up resources and listeners here
    super.dispose();
  }
}
