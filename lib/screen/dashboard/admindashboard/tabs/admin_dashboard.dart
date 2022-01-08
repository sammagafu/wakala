import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/admindashboard/agentdashboard.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/transaction_on_move.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  late var requestingUser;

  final Stream<QuerySnapshot> _transaction = FirebaseFirestore.instance
      .collection('transaction')
      .where("is_active", isEqualTo: true)
      .where('is_completed', isEqualTo: false)
      .where("status", isEqualTo: "started")
      .limit(1)
      .snapshots(includeMetadataChanges: true);

  final CollectionReference ttrips =
      FirebaseFirestore.instance.collection("transaction_trips");

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kPrimaryColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: _transaction,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text(
                        "Looking for clients please wait",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
                );
              }
              var _transactionData = snapshot.data!.docs.first;
              var _requestingUser = _transactionData["user"];
              return DraggableScrollableSheet(
                  initialChildSize: 0.45,
                  minChildSize: 0.13,
                  maxChildSize: 0.9,
                  builder:
                      (BuildContext buildContext, ScrollController controller) {
                    FlutterRingtonePlayer.play(
                      android: AndroidSounds.notification,
                      ios: const IosSound(1023),
                      looping: true,
                      volume: 1.0,
                    );
                    return Container(
                      color: kPrimaryColor,
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: Column(
                        children: [
                          Text(
                            "Transaction information",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Service provider"),
                              Text(_transactionData["carrier"]),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Service"),
                              Text(_transactionData["service"]),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Amount to ${_transactionData["service"]}"),
                              Text(_transactionData["amount"]),
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('transaction')
                                  .doc(_transactionData.id)
                                  .update({
                                'status': "ongoing",
                                'is_active': false,
                                'agent': FirebaseAuth.instance.currentUser!.uid
                              });

                              ttrips.doc(_transactionData.id).set({
                                'agent': FirebaseAuth.instance.currentUser!.uid,
                                'transaction': _transactionData.id,
                                "accepted_time": Timestamp.now(),
                              });
                              FlutterRingtonePlayer.stop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TransactionOnMove(_transactionData.id),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(8),
                                backgroundColor: kSecondaryColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Accept ",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                                const Icon(
                                  Icons.done,
                                  color: kContentDarkTheme,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
