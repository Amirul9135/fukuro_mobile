import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_editor_controller.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/fukuro_form.dart';

import 'package:fukuro_mobile/Controller/utilities.dart';

class NodeForm extends StatefulWidget {
  @override
  NodeFormState createState() => NodeFormState();
  NodeForm({Key? key, this.origin, this.readonly, this.nokey, this.showId})
      : super(key: key);
  Node? origin;
  bool? readonly;
  bool? nokey;
  bool? showId;
}

class NodeFormState extends State<NodeForm> {
  // Declare your variables and properties here

  final GlobalKey<FukuroFormState> keyForm = GlobalKey();
  final FukuroEditorController txtNodeName = FukuroEditorController();
  final FukuroEditorController txtDescription = FukuroEditorController();
  final FukuroEditorController txtPassKey = FukuroEditorController();
  final FukuroEditorController txtNodeId = FukuroEditorController();
  Node thisNode = Node();
  bool _lock = false;
  bool noKey = false;
  @override
  void initState() {
    // Initialize your state here
    super.initState();

    thisNode = widget.origin ?? thisNode;
    _lock = widget.readonly ?? _lock;
    noKey = widget.nokey ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dynamic tst = thisNode.getPassKey();
      print('callback inner $noKey');
      txtNodeName.text = thisNode.getName();
      txtDescription.text = thisNode.getDescription();
      txtNodeId.text = thisNode.getNodeId().toString();
      if (_lock) {
        txtPassKey.text = censorString(thisNode.getPassKey());
      } else {
        txtPassKey.text = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build your widget tree here 
    Map<String, Map<String, dynamic>> fields = {};

    if (widget.showId ?? false) {
      fields['nodeId'] = FukuroFormFieldBuilder(
        readOnly: true,
        fieldName: "Node Id",
        controller: txtNodeId,
        type: FukuroForm.inputText,
        value: thisNode.getNodeId().toString(),
      ).build();
    }
    fields['name'] = FukuroFormFieldBuilder(
      readOnly: _lock,
      fieldName: "Node Name",
      controller: txtNodeName,
      type: FukuroForm.inputText,
      value: thisNode.getName(),
    ).build();
    fields['description'] = FukuroFormFieldBuilder(
            readOnly: _lock,
            fieldName: "Description",
            controller: txtDescription,
            type: FukuroForm.inputText,
            value: thisNode.getDescription())
        .build();
    if (!noKey) {
      fields['passKey'] = FukuroFormFieldBuilder(
        readOnly: _lock,
        fieldName: "Pass Key",
        controller: txtPassKey,
        type: FukuroForm.inputText,
        value: censorString(thisNode.getPassKey()),
      ).build();
    }
    return FukuroForm(key: keyForm, fields: fields);
  }

  toggleLock(bool lock) {
    print('toggle in nfrom $lock');
    setState(() {
      widget.readonly = lock;
      _lock = lock;
    });
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
          setState(() {});

          Navigator.pushNamed(context, '/home', arguments: 1);
        }
      } else {
        if (mounted) {
          showDialog(
              context: context,
              builder: (_) => FukuroDialog(
                  title: 'Error', message: '', mode: FukuroDialog.ERROR));
        }
      }
    }
  }

  _readValue() {
    thisNode.setName(txtNodeName.text);
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
                  title: 'Saved', message: '', mode: FukuroDialog.SUCCESS));
        }
      } else {
        if (mounted) {
          showDialog(
              context: context,
              builder: (_) => FukuroDialog(
                  title: 'Error', message: '', mode: FukuroDialog.ERROR));
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
