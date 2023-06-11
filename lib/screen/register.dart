import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  final userFormKey = GlobalKey<_UserFormState>();
  final securityFormKey = GlobalKey<_SecurityFormState>();
  late TabController _tabController;

  final _selectedColor = const Color(0xff1a73e8);

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

  validateAll() {
    if ((userFormKey.currentState?._formKey.currentState?.validate() ?? false ) & (securityFormKey.currentState?._formKey.currentState?.validate() ?? false)) {
      showDialog(
          context: context,
          builder: (_) => const CupertinoAlertDialog(
                title: Text("Error"),
                content: Text("Invalid User Credentials Please check again"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _UserForm userForm = _UserForm(
      key: userFormKey,
      formData: userData,
    );
    _SecurityForm secForm =
        _SecurityForm(key: securityFormKey, formData: securityData);
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
          validateAll();
        },

        label: const Text('Register'),
        icon: const Icon(Icons.navigate_next_sharp),
        hoverColor: Colors.blue, // Optional: Change the hover color
        hoverElevation: 10, // Optional: Adjust the elevation on hover
      ),
    );
  }

  onTabChange() {
    setState(() {
      var tmpName = userFormKey.currentState?.txtName.text ?? '';
      var tmpUsername = userFormKey.currentState?.txtUsername.text ?? '';
      var tmpEmail = userFormKey.currentState?.txtEmail.text ?? '';
      var tmpPhone = userFormKey.currentState?.txtPhone.text ?? '';
      var tmpPass = securityFormKey.currentState?.txtPass.text ?? '';
      var tmpCPass = securityFormKey.currentState?.txtConfPass.text ?? '';
      var tmpPin = securityFormKey.currentState?.txtPin.text ?? '';
      var tmpCPin = securityFormKey.currentState?.txtConfPin.text ?? '';

      if (tmpName.isNotEmpty) {
        userData["name"] = tmpName;
      }
      if (tmpUsername.isNotEmpty) {
        userData["username"] = tmpUsername;
      }
      if (tmpEmail.isNotEmpty) {
        userData["email"] = tmpEmail;
      }
      if (tmpPhone.isNotEmpty) {
        userData["phone"] = tmpPhone;
      }
      if (tmpPass.isNotEmpty) {
        securityData["pass"] = tmpPass;
      }
      if (tmpCPass.isNotEmpty) {
        securityData["cpass"] = tmpCPass;
      }
      if (tmpPin.isNotEmpty) {
        securityData["pin"] = tmpPin;
      }
      if (tmpCPin.isNotEmpty) {
        securityData["cpin"] = tmpCPin;
      }
      print(userData);
    });
  }
}

class _UserForm extends StatefulWidget {
  const _UserForm({Key? key, required this.formData}) : super(key: key);
  final Map<String, String> formData;

  @override
  State<_UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<_UserForm>  {
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    txtName.text = widget.formData["name"].toString();
    txtUsername.text = widget.formData["username"].toString();
    txtEmail.text = widget.formData["email"].toString();
    txtPhone.text = widget.formData["phone"].toString();

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _gap(),
            const Text(
              "User Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              height: 2,
              thickness: 3,
              indent: 30,
              endIndent: 30,
              color: Colors.black,
            ),
            _gap(),
            TextFormField(
              controller: txtName,
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }

                bool emailValid = RegExp(r"^[a-zA-z0-9]{6,}").hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_box_outlined),
              ),
            ),
            _gap(),
            TextFormField(
              controller: txtUsername,
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }

                bool emailValid = RegExp(r"^[a-zA-z0-9]{6,}").hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                helperText: "Used as your log in credential",
                prefixIcon: Icon(Icons.account_circle_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: txtEmail,
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }

                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: txtPhone,
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }

                bool emailValid = RegExp(
                        r"^[0-9]{10,}") //chage regex later
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid phone number';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Phone No.',
                hintText: 'Enter your Contact number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

class _SecurityForm extends StatefulWidget {
  const _SecurityForm({Key? key, required this.formData}) : super(key: key);
  final Map<String, String> formData;

  @override
  State<_SecurityForm> createState() => _SecurityFormState();
}

class _SecurityFormState extends State<_SecurityForm> {
  TextEditingController txtPass = TextEditingController();
  TextEditingController txtConfPass = TextEditingController();
  TextEditingController txtPin = TextEditingController();
  TextEditingController txtConfPin = TextEditingController();
  bool isPassVis = false;
  bool isConfPassVis = false;
  bool isPinVis = false;
  bool isConfPinVis = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    txtPass.text = widget.formData["pass"].toString();
    txtConfPass.text = widget.formData["cpass"].toString();
    txtPin.text = widget.formData["pin"].toString();
    txtConfPin.text = widget.formData["cpin"].toString();
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _gap(),
            const Text(
              "Security Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              height: 2,
              thickness: 3,
              indent: 30,
              endIndent: 30,
              color: Colors.black,
            ),
            _gap(),
            TextFormField(
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
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
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
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }

                if (value.length < 6) {
                  return 'Pin must be at least 6 characters';
                }
                return null;
              },
              obscureText: !isPinVis,
              decoration: InputDecoration(
                  labelText: 'Security PIN',
                  hintText: 'Enter your Security PIN',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isPinVis ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        isPinVis = !isPinVis;
                      });
                    },
                  )),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !isConfPinVis,
              decoration: InputDecoration(
                  labelText: 'Confirm PIN',
                  hintText: 'Re-Enter your Security PIN',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isConfPinVis ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        isConfPinVis = !isConfPinVis;
                      });
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

class MaterialDesignIndicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;

  const MaterialDesignIndicator({
    required this.indicatorHeight,
    required this.indicatorColor,
  });

  @override
  createBoxPainter([VoidCallback? onChanged]) {
    return _MaterialDesignPainter(this, onChanged);
  }
}

class _MaterialDesignPainter extends BoxPainter {
  final MaterialDesignIndicator decoration;

  _MaterialDesignPainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Rect rect = Offset(
          offset.dx,
          configuration.size!.height - decoration.indicatorHeight,
        ) &
        Size(configuration.size!.width, decoration.indicatorHeight);

    final Paint paint = Paint()
      ..color = decoration.indicatorColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: const Radius.circular(8),
        topLeft: const Radius.circular(8),
      ),
      paint,
    );
  }
}
