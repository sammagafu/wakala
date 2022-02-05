// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/welcomescreen/login.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  // final bool _isuser = false;
  // final _userprofile = FirebaseFirestore.instance.collection("user_profile");

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, LoginScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
      ),
    );
  }
}
