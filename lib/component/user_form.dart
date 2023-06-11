import 'package:flutter/material.dart';  

class UserForm extends StatefulWidget {
  const UserForm({Key? key, required this.formData}) : super(key: key);
  final Map<String, String> formData;

  @override
  State<UserForm> createState() => UserFormState();
}

class UserFormState extends State<UserForm>  {
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 
  getFormKey(){
    return _formKey;
  }
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
 