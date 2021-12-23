import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/registration/registerAgent.dart';
import 'package:wakala/screen/registration/registerClient.dart';
import 'package:wakala/screen/welcomescreen/login.dart';

class CreateAccount extends StatelessWidget {
  static String id = "Create Account";
  const CreateAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          SizedBox(height: 100),
          Text(
            "What are you ?",
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  NeumorphicButton(
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(20),
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterUserClient.id);
                    },
                    style: NeumorphicStyle(
                      lightSource: LightSource.topLeft,
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      color: kPrimaryColor,
                    ),
                    child: Icon(
                      Icons.person,
                      color: kContentDarkTheme,
                      size: 80,
                    ),
                  ),
                  Text(
                    "Client",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Column(
                children: [
                  NeumorphicButton(
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(20),
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterUserAgent.id);
                    },
                    style: NeumorphicStyle(
                      lightSource: LightSource.topLeft,
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      color: kPrimaryColor,
                    ),
                    child: Icon(
                      Icons.business_center_outlined,
                      color: kContentDarkTheme,
                      size: 80,
                    ),
                  ),
                  Text(
                    "Agent",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 60),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
            style: TextButton.styleFrom(primary: Colors.white70),
            child: Text(
              'Have an account? Login',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }
}
