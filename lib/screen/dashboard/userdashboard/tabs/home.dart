import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/withdraw.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/deposit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance.currentUser;
  final _database = FirebaseFirestore.instance;
  final _db = FirebaseFirestore.instance.collection("transaction");
  var _currentUserProfile = '';
  var _currentDeposit = '';
  var _currentWithdraw = '';
  String _service = '';
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
      padding: EdgeInsets.fromLTRB(15, 100, 15, 30),
      color: kPrimaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Welcome",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "$_currentUserProfile",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(height: 65),
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
                    padding: EdgeInsets.all(24),
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
                    padding: EdgeInsets.all(24),
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
          SizedBox(height: 24),
          const Text("My last activities"),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("transaction")
                  .where("user", isEqualTo: _auth?.uid)
                  .limit(8)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                        color: kContentDarkTheme,
                                      )
                                    : const Icon(
                                        Icons.arrow_circle_up,
                                        color: kContentDarkTheme,
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(messages.elementAt(index)['service']),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(messages.elementAt(index)['carrier']),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(messages.elementAt(index)['amount']),
                              ],
                            ),
                          ],
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
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
