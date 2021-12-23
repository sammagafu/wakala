import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/admindashboard/agentdashboard.dart';
import 'package:wakala/screen/dashboard/userdashboard/userdashboard.dart';
import 'package:wakala/screen/welcomescreen/createaccount.dart';

class LoginScreen extends StatefulWidget {
  static String id = "Login Account";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection("user_profile");
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 135, 20, 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 50),
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  color: kContentDarkTheme,
                  height: 85.0,
                ),
                SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  controller: emailController,
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
                      Icons.person,
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
                SizedBox(height: 18),
                TextFormField(
                  controller: passwordController,
                  autofocus: false,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter your Password");
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
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
                SizedBox(height: 12),
                Text(
                  errorMessage,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(color: kErrorColor),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NeumorphicButton(
                      margin: EdgeInsets.only(top: 12),
                      padding: EdgeInsets.all(25),
                      onPressed: signIn,
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
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Forgot your password ?"),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Reset Password",
                        style: TextStyle(color: kErrorColor, fontSize: 18),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Dont have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CreateAccount.id);
                      },
                      child: Text(
                        "create account",
                        style: TextStyle(color: kErrorColor, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        var userData = FirebaseAuth.instance.currentUser;

        var userStatus =
            await _firestore.where("uiid", isEqualTo: userData?.uid).get();
        var is_agent = userStatus.docs.first.get("is_agent");
        print(userStatus.docs.first.data());
        if (is_agent == true) {
          Navigator.pushNamed(context, AgentDashboard.id);
        } else {
          Navigator.pushNamed(context, UserDashboard.id);
        }
      } on FirebaseAuthException catch (err) {
        if (err.code == 'user-not-found') {
          setState(() {
            errorMessage = "Wrong Email Entered please check";
          });
        } else if (err.code == 'wrong-password') {
          setState(() {
            errorMessage = "Wrong Password please try again";
          });
        }
      }
    }
  }
}
