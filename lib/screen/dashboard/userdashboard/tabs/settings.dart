import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/welcomescreen/login.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _isagent = false;
  final _userprofile = FirebaseFirestore.instance.collection("user_profile");

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, LoginScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 65, 15, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              "Settings",
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: kPrimaryColor),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              "Account Settings",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: kPrimaryColor),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              height: MediaQuery.of(context).size.width * .14,
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 5, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Go Offline"),
                    Switch(
                      value: _isagent,
                      onChanged: (value) {
                        setState(() {
                          _isagent = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.fromLTRB(40, 15, 20, 15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Update Profile",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: kContentDarkTheme,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.fromLTRB(40, 15, 20, 15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Password",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: kContentDarkTheme,
                  )
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _signOut,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.fromLTRB(40, 15, 20, 15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Logout",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 34,
            )
          ],
        ),
      ),
    );
  }
}
