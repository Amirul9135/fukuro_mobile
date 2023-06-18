import 'package:flutter/material.dart';
import 'package:fukuro_mobile/View/login.dart';
import 'package:fukuro_mobile/View/Component/security_form.dart';
import 'package:fukuro_mobile/View/Component/user_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';

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

  var _firstChange = true;

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
   bool isValidUserData = false;
   bool isValidSecurityData = false;

  final _iconTabs = const [
    Tab(icon: Icon(Icons.account_circle)),
    Tab(icon: Icon(Icons.security)),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(onTabChange);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            Container(
              alignment: Alignment.topCenter,
              child: userForm,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: secForm,
            ),
          ]))
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

  valiateSubmit() async { 
    _saveInputValue();
    if (isValidSecurityData && !isValidUserData && _tabController.index == 1) {
      showDialog(
          context: context,
          builder: (_) => FukuroDialog(
                title: "Invalid User Information",
                message: "Please Check your User information",
                mode: FukuroDialog.ERROR,
                okAction: () {
                  _tabController.animateTo(0);
                },
              ));
      return;
    }
    if (isValidUserData && !isValidSecurityData && _tabController.index == 0) {
      showDialog(
          context: context,
          builder: (_) => FukuroDialog(
                title: "Invalid Security Details",
                message: "Please Check your Security Details",
                mode: FukuroDialog.ERROR,
                okAction: () {
                  _tabController.animateTo(1);
                },
              ));
      return;
    }
    if (isValidUserData && isValidSecurityData) {
      _saveInputValue();
      http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "name": userData["name"].toString(),
          "username": userData["username"].toString(),
          "email": userData["email"].toString(),
          "password": securityData["pass"].toString(),
          "phone": userData["phone"].toString(),
          "pin": securityData["pin"].toString()
        }),
      );
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
    isValidUserData =  userFormKey.currentState?.getFormKey().currentState?.validate() ?? isValidUserData ?? false;
    
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
    isValidSecurityData =  securityFormKey.currentState?.getFormKey().currentState?.validate() ?? isValidSecurityData ?? false;
  }

  onTabChange() {
    if (_tabController.indexIsChanging) {
      // Animation is in progress
      //do nothing
      return;
    }
    if (!_firstChange) {
      if (_tabController.index == 0) {
        userFormKey.currentState?.getFormKey().currentState?.validate();
      }
      if (_tabController.index == 1) {
        securityFormKey.currentState?.getFormKey().currentState?.validate();
      }
    }
    if (_firstChange) {
      //first time no need to do anything yet
      _firstChange = false;
      return;
    } 

    setState(() {
      _saveInputValue();
    });
  }
}
