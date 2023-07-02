import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_editor_controller.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/fukuro_form.dart';

class NodeForm extends StatefulWidget {
  @override
  NodeFormState createState() => NodeFormState();
  const NodeForm({Key? key}) : super(key: key);
}

class NodeFormState extends State<NodeForm> {
  // Declare your variables and properties here

  final GlobalKey<FukuroFormState> keyForm = GlobalKey();
  final FukuroEditorController txtNodeName = FukuroEditorController();
  final FukuroEditorController txtDescription = FukuroEditorController();
  final FukuroEditorController txtIpAddress = FukuroEditorController();
  final FukuroEditorController txtPassKey = FukuroEditorController();
  final Node thisNode = Node();
  @override
  void initState() {
    // Initialize your state here
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build your widget tree here

    return FukuroForm(key: keyForm, fields: {
      'name': FukuroFormFieldBuilder(
        fieldName: "Node Name",
        controller: txtNodeName,
        type: FukuroForm.inputText,
        value: thisNode.getName(),
      ).build(),
      'description': FukuroFormFieldBuilder(
              fieldName: "Description",
              controller: txtDescription,
              type: FukuroForm.inputText,
              value: thisNode.getDescription())
          .build(),
      'ipAddress': FukuroFormFieldBuilder(
              fieldName: "IP Address",
              controller: txtIpAddress,
              type: FukuroForm.inputText,
              value: thisNode.getIpAddress())
          .build(),
      'passKey': FukuroFormFieldBuilder(
        fieldName: "Pass Key",
        controller: txtPassKey,
        type: FukuroForm.inputText,
        value: thisNode.getPassKey(),

      ).build(),
    });
  }

  loadData(Node node) {
    print('load x');
    txtNodeName.text = node.getName();
    txtDescription.text = node.getDescription();
    txtIpAddress.text = node.getIpAddress();
    txtPassKey.text = node.getPassKey(); 
  }

  save() async {
    if (validate()) {
      _readValue();
      if (await thisNode.submitToServer()) {
        if (mounted) {
          showDialog(
              context: context,
              builder: (_) => FukuroDialog(
                  title: 'Registered',
                  message: '',
                  mode: FukuroDialog.SUCCESS));
                  
            Navigator.pushNamed(context, '/home', arguments: 1);
        }
      }
      else{
        if(mounted){
          
          showDialog(
              context: context,
              builder: (_) => FukuroDialog(
                  title: 'Error',
                  message: '',
                  mode: FukuroDialog.ERROR));
        }
      }
    }
  }

  _readValue(){
      thisNode.setName(txtNodeName.text);
      thisNode.setIpAddress(txtIpAddress.text);
      thisNode.setDescription(txtDescription.text);
      thisNode.setPassKey(txtPassKey.text);
  }


  update(int id) async {
    if (validate()) {
      _readValue();
      thisNode.setNodID(id);
      if (await thisNode.saveToServer()) {
        if (mounted) {
          showDialog(
              context: context,
              builder: (_) => FukuroDialog(
                  title: 'Saved',
                  message: '',
                  mode: FukuroDialog.SUCCESS)); 
        }
      }
      else{
        if(mounted){
          
          showDialog(
              context: context,
              builder: (_) => FukuroDialog(
                  title: 'Error',
                  message: '',
                  mode: FukuroDialog.ERROR));
        }
      }
    }
  }

  bool validate() {
    return keyForm.currentState?.validateForm() ?? false;
  }

  @override
  void dispose() {
    // Clean up resources and listeners here
    super.dispose();
  }
}
