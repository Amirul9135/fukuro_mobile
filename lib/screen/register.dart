import 'package:flutter/material.dart';
import 'package:fukuro_mobile/screen/login.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:fukuro_mobile/component/security_form.dart';
import 'package:fukuro_mobile/component/user_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fukuro_mobile/component/fukuro_dialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = const Color(0xff1a73e8);

  final userFormKey = GlobalKey<UserFormState>();
  final securityFormKey = GlobalKey<SecurityFormState>();

  final Map<String, String> userData = {
    "name": "",
    "username": "",
    "email": "",
    "phone": ""
  };
  final Map<String, String> securityData = {
    "pass": "",
    "cpass": "",
    "pin": "",
    "cpin": ""
  };

  final _iconTabs = const [
    Tab(icon: Icon(Icons.account_circle)),
    Tab(icon: Icon(Icons.security)),
    Tab(icon: Icon(Icons.list)),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(onTabChange);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  valiateSubmit() async {
    if ((userFormKey.currentState?.getFormKey().currentState?.validate() ??
            false) &
        (securityFormKey.currentState?.getFormKey().currentState?.validate() ??
            false)) {
      _saveInputValue();
      Map<String, String> payload = {
        "name": userData["name"].toString(),
        "username": userData["username"].toString(),
        "email": userData["email"].toString(),
        "password": securityData["pass"].toString(),
        "phone": userData["phone"].toString(),
        "pin": securityData["pin"].toString()
      };
      print(payload);
      http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );
      print(response.body);
      if (mounted) {
        print(response.body);
        if (response.statusCode == 200) {
          //success register
          showDialog(
              context: context,
              builder: (_) => FukuroDialog(
                    title: "Success",
                    message: "Registered",
                    mode: FukuroDialog.SUCCESS,
                    okAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                  ));
        } else if (response.statusCode == 409) {
          //username taken
          showDialog(
              context: context,
              builder: (_) => FukuroDialog(
                  title: "Warning",
                  message: "Username already in use",
                  mode: FukuroDialog.WARNING));
        } else {
          showDialog(
              context: context,
              builder: (_) => FukuroDialog(
                  title: "Error",
                  message: "Failed to register please try again",
                  mode: FukuroDialog.ERROR));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserForm userForm = UserForm(
      key: userFormKey,
      formData: userData,
    );
    SecurityForm secForm =
        SecurityForm(key: securityFormKey, formData: securityData);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: _selectedColor,
          title: const Text("Register New Account")),
      body: Column(
        children: [
          Center(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: _iconTabs,
                      unselectedLabelColor: Colors.black,
                      labelColor: _selectedColor,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        color: _selectedColor.withOpacity(0.2),
                      ),
                    ),
                    SingleChildScrollView(
                        child: SizedBox(
                      height: 80.h,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (_tabController.index == 2 ||
                              _tabController.index == 0)
                            userForm,
                          if (_tabController.index == 2 ||
                              _tabController.index == 1)
                            secForm
                        ]
                            .map((item) => Column(
                                  /// Added a divider after each item to let the tabbars have room to breathe
                                  children: [
                                    item,
                                    const Divider(color: Colors.transparent)
                                  ],
                                ))
                            .toList(),
                      ),
                    )),
                  ],
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action to perform when the button is pressed
          valiateSubmit();
        },

        label: const Text('Register'),
        icon: const Icon(Icons.navigate_next_sharp),
        hoverColor: Colors.blue, // Optional: Change the hover color
        hoverElevation: 10, // Optional: Adjust the elevation on hover
      ),
    );
  }

  _saveInputValue() {
    userData["name"] =
        userFormKey.currentState?.txtName.text ?? userData["name"] ?? '';
    userData["username"] = userFormKey.currentState?.txtUsername.text ??
        userData["username"] ??
        '';
    userData["email"] =
        userFormKey.currentState?.txtEmail.text ?? userData["email"] ?? '';
    userData["phone"] =
        userFormKey.currentState?.txtPhone.text ?? userData["phone"] ?? '';
    //security
    securityData["pass"] = securityFormKey.currentState?.txtPass.text ??
        securityData["pass"] ??
        '';
    securityData["cpass"] = securityFormKey.currentState?.txtConfPass.text ??
        securityData["cpass"] ??
        '';
    securityData["pin"] =
        securityFormKey.currentState?.txtPin.text ?? securityData["pin"] ?? '';
    securityData["cpin"] = securityFormKey.currentState?.txtConfPin.text ??
        securityData["cpin"] ??
        '';
  }

  onTabChange() {
    setState(() {
      _saveInputValue();
    });
  }
}
