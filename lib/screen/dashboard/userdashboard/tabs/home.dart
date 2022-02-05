import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/withdraw.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/deposit.dart';
import 'package:wakala/screen/welcomescreen/login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance.currentUser;
  final _database = FirebaseFirestore.instance;
  final _db = FirebaseFirestore.instance.collection("transaction");
  final bool _isuser = false;
  final _userprofile = FirebaseFirestore.instance.collection("user_profile");
  var _currentUserProfile = '';

  late Future<String?> userToken;

  Future<void> getUserProfile() async {
    var userprofie = await _database
        .collection("user_profile")
        .where("uiid", isEqualTo: _auth?.uid)
        .get();
    setState(() {
      _currentUserProfile = userprofie.docs.first.get("fullname");
    });
  }

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 65, 15, 30),
      // color: kPrimaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Welcome",
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: kPrimaryColor),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Text(
                  "$_currentUserProfile",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: kPrimaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Container(
            height: 1,
            color: kPrimaryColor,
            width: MediaQuery.of(context).size.width * .45,
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Switch to Agent account",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: kPrimaryColor),
              ),
              Switch(
                  value: _isuser,
                  onChanged: (value) {
                    var _loginedUser =
                        _userprofile.doc(_auth!.uid).update({'is_agent': true});
                    Navigator.pushNamed(context, LoginScreen.id);
                  }),
            ],
          ),
          const SizedBox(height: 65),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Withdraw.id);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: kContentColorLightTheme,
                  elevation: 5,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          "Make withdraw",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Deposit.id);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: kSecondaryColor,
                  elevation: 5,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          "Make Deposit",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: kContentColorLightTheme),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "My last activities",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: kPrimaryColor),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db
                  .where("user", isEqualTo: _auth?.uid)
                  .orderBy("request_time", descending: false)
                  .limit(8)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {}
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final messages = snapshot.data!.docs;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                messages.elementAt(index)['service'] ==
                                        'withdraw'
                                    ? const Icon(
                                        Icons.arrow_circle_down,
                                        color: kPrimaryColor,
                                      )
                                    : const Icon(
                                        Icons.arrow_circle_up,
                                        color: kPrimaryColor,
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  messages.elementAt(index)['service'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: kPrimaryColor),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  messages.elementAt(index)['carrier'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: kPrimaryColor),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  messages.elementAt(index)['amount'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: kPrimaryColor),
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                } else {
                  return Center(
                    child: Text(
                      "No recent activities",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: kPrimaryColor),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
