import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:fukuro_mobile/View/Component/fukuro_form.dart'; 
import 'package:fukuro_mobile/View/Component/user_form.dart'; 

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState(); 
}

class ProfileState extends State<Profile>
    with SingleTickerProviderStateMixin {
  final Map<String, Map<dynamic, dynamic>> fields = {};
  TextEditingController txtPass = TextEditingController();
  TextEditingController txtConfPass = TextEditingController();
  bool isPassVis = false;
  bool isConfPassVis = false;
 
  @override
  void initState() {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      appBar: AppBar(title: const Text("User Profile")),
      body: const UserForm(fabIcon: Icon(Icons.navigate_next_sharp),fabText: "Update",register: false,onlyChangeable: true,),
    );
  }
 
}
