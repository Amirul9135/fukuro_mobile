import 'package:flutter/material.dart'; 
import 'package:flutter/cupertino.dart'; 

class SecurityForm extends StatefulWidget {
  const SecurityForm({Key? key, required this.formData}) : super(key: key);
  final Map<String, String> formData;

  @override
  State<SecurityForm> createState() => SecurityFormState();
}

class SecurityFormState extends State<SecurityForm> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  getFormKey(){
    return _formKey;
  }
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
            _gap(),
            TextFormField(
              controller: txtConfPass,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                if(value != txtPass.text){
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
            _gap(),
            TextFormField(
              controller: txtPin,
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
              controller: txtConfPin,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                if(value != txtPin.text){
                  return 'Must be same as PIN';
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
