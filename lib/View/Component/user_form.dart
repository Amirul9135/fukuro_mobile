import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/Authentication.dart';
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/fukuro_form.dart';
import 'package:sizer/sizer.dart';

class UserForm extends StatefulWidget {
  final String fabText;
  final Icon fabIcon;
  final bool register;
  const UserForm({
    Key? key,
    required this.fabIcon,
    required this.fabText,
    required this.register,
    
  }) : super(key: key);

  @override
  State<UserForm> createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final Map<String, Map<dynamic, dynamic>> fields = {};
  TextEditingController txtPass = TextEditingController();
  TextEditingController txtConfPass = TextEditingController();
  bool isPassVis = false;
  bool isConfPassVis = false;

  final GlobalKey<FukuroFormState> _formKey = GlobalKey<FukuroFormState>();
  final GlobalKey<FormState> _passFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fields["Name"] = FukuroFormFieldBuilder(
            fieldName: "Name",
            type: FukuroForm.inputText,
            lengthMin: 6,
            hint: 'Enter your name',
            icon: Icon(Icons.account_box_outlined))
        .build();
    fields["Username"] = FukuroFormFieldBuilder(
            fieldName: "Username",
            type: FukuroForm.inputText,
            lengthMin: 6,
            hint: 'Enter your username',
            icon: Icon(Icons.account_circle_outlined),
            help: "Used as your log in credential")
        .build();
    fields["Email"] = FukuroFormFieldBuilder(
            fieldName: "Email",
            type: FukuroForm.inputText,
            hint: 'Enter your Email',
            icon: Icon(Icons.email_outlined),
            validator:
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .build();
    fields["Phone"] = FukuroFormFieldBuilder(
            fieldName: "Phone",
            type: FukuroForm.inputNumerical,
            hint: 'Enter your Contact Number',
            icon: Icon(Icons.phone),
            validator: r"^[0-9]{10,}")
        .build();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 5.h),
          child: SingleChildScrollView(
              child: Column(children: [
            FukuroForm(key: _formKey, fields: fields),
            Form(key: _passFormKey, child: Column(children: [
               Container(
              padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
              child: TextFormField(
                controller: txtPass,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cannot be empty';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                obscureText: !isPassVis,
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(CupertinoIcons.lock_shield_fill),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          isPassVis ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isPassVis = !isPassVis;
                        });
                      },
                    )),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
              child: TextFormField(
                controller: txtConfPass,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cannot be empty';
                  }
                  if (value != txtPass.text) {
                    return 'Must be same with password';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                obscureText: !isConfPassVis,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-Enter your password',
                    prefixIcon: const Icon(CupertinoIcons.lock_shield_fill),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(isConfPassVis
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isConfPassVis = !isConfPassVis;
                        });
                      },
                    )),
              ),
            ),
         
            ],)) ]))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action to perform when the button is pressed
          _processUserData();
        },

        label:  Text(widget.fabText),
        icon: widget.fabIcon,
        hoverColor: Colors.blue, // Optional: Change the hover color
        hoverElevation: 10, // Optional: Adjust the elevation on hover
      ),
    );
  }
  _processUserData() async {
    bool validate1 = _formKey.currentState?.validateForm() ?? false;
    bool validate2 = _passFormKey.currentState?.validate() ?? false;
    if(validate1 && validate2){
      Map<String,dynamic> userdata = {};
      userdata["name"] = fields["Name"]!["controller"]!.getValueStr();
      userdata["username"] = fields["Username"]!["controller"]!.getValueStr();
      userdata["email"] = fields["Email"]!["controller"]!.getValueStr();
      userdata["phone"] = fields["Phone"]!["controller"]!.getValueStr();
      userdata["password"] = txtPass.text;
      if(widget.register){
        FukuroResponse res = await Authentication.register(userdata);
        if(!mounted){
          return;
        }
        if(res.ok()){
          await FukuroDialog.success(context, "registered", "Proceed to login");
          
            Navigator.pushNamed(context, '/');
        }else{
          FukuroDialog.error(context, "Failed to register", res.msg().toString());
        }
      }
    }
    else{
      FukuroDialog.error(context, "Invalid input", "Please ensure all field are correctly inserted");

    }
  }
}
