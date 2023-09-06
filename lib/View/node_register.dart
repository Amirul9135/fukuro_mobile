import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/View/Component/node_form.dart';
import 'package:sizer/sizer.dart';

class NodeRegister extends StatefulWidget {
  const NodeRegister({Key? key}) : super(key: key);
  @override
  NodeRegisterState createState() => NodeRegisterState();
}

class NodeRegisterState extends State<NodeRegister> {
  // Declare your variables and properties here
  final GlobalKey<NodeFormState> formStateKey = GlobalKey();
  NodeForm form = NodeForm();
  @override
  void initState() {
    // Initialize your state here
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build your widget tree here
    form = NodeForm(
      key: formStateKey,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Register New Node'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/home', arguments: 1);
            },
          ),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
            child: SingleChildScrollView(
                child: Column(children: [
              verticalGap(20),
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
                      'Register',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    registerNode();
                  },
                ),
              ),
            ])))
            );
  }

  registerNode() {
    formStateKey.currentState?.save();
  }

  @override
  void dispose() {
    // Clean up resources and listeners here
    super.dispose();
  }
}
