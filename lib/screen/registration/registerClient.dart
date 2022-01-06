import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/welcomescreen/login.dart';

class RegisterUserClient extends StatefulWidget {
  static final String id = "registerclient";
  const RegisterUserClient({Key? key}) : super(key: key);

  @override
  _RegisterUserClientState createState() => _RegisterUserClientState();
}

class _RegisterUserClientState extends State<RegisterUserClient> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection("user_profile");
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: kPrimaryColor,
          padding: EdgeInsets.only(top: 100, left: 18, right: 18, bottom: 100),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  "Create an Account as client",
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 32),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: fullnameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter your full name");
                    }
                    if (!RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$")
                        .hasMatch(value)) {
                      return ("Enter the valid email");
                    }
                    return null;
                  },
                  onSaved: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: kContentDarkTheme,
                    ),
                    labelText: "Enter your full name",
                    labelStyle: TextStyle(color: kContentDarkTheme),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter your Email");
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Enter the valid email");
                    }
                    return null;
                  },
                  onSaved: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_sharp,
                      color: kContentDarkTheme,
                    ),
                    labelText: "Enter your email",
                    labelStyle: TextStyle(color: kContentDarkTheme),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter phone number");
                    }
                    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                        .hasMatch(value)) {
                      return ("Enter the valid phone number");
                    }
                    return null;
                  },
                  onSaved: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: kContentDarkTheme,
                    ),
                    labelText: "Enter your phone number",
                    labelStyle: TextStyle(color: kContentDarkTheme),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter password");
                    }
                    if (value.length < 8) {
                      return ("Entered password must have 8 or more characters and numbers");
                    }
                    return null;
                  },
                  onSaved: (value) {},
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: kContentDarkTheme,
                    ),
                    labelText: "Enter your password",
                    labelStyle: TextStyle(color: kContentDarkTheme),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter your password");
                    }
                    if (value.length < 8) {
                      return ("Entered password must have 8 or more characters and numbers");
                    }
                    if (value != passwordController.text) {
                      return ("Password dont match");
                    }
                    return null;
                  },
                  onSaved: (value) {},
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: kContentDarkTheme,
                    ),
                    labelText: "confirm your password",
                    labelStyle: TextStyle(color: kContentDarkTheme),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Create account"),
                    NeumorphicButton(
                      margin: EdgeInsets.only(top: 12),
                      padding: EdgeInsets.all(25),
                      onPressed: createUserClient,
                      style: NeumorphicStyle(
                        lightSource: LightSource.topLeft,
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.circle(),
                        color: kPrimaryColor,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: kContentDarkTheme,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      side: BorderSide(color: Colors.white)),
                  child: Row(
                    children: [
                      Text(
                        "I have Account Log in",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: kContentDarkTheme,
                        size: 16,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUserClient() async {
    final _formstate = _formKey.currentState;
    if (_formstate!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        await _auth.currentUser!.updateDisplayName(fullnameController.text);
        await _db.doc(_auth.currentUser!.uid).set({
          'fullname': fullnameController.text,
          'is_agent': false,
          'is_user': true,
          'phone_number': phoneNumberController.text,
          'uiid': _auth.currentUser!.uid
        });
        Navigator.pushNamed(context, LoginScreen.id);
      } on FirebaseAuthException catch (err) {
        if (err.code == 'email-already-in-use') {
          setState(() {
            errorMessage =
                "The email address is already in use by another account";
          });
        }
      }
    }
  }
}
