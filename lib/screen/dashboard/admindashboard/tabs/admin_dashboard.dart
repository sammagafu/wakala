import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/admindashboard/agentdashboard.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/transaction_on_move.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  double _latitude = 0;
  double _longitude = 0;
  late var requestingUser;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var _mylocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latitude = _mylocation.latitude;
      _longitude = _mylocation.longitude;
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  final Stream<QuerySnapshot> _transaction = FirebaseFirestore.instance
      .collection('transaction')
      .where("is_active", isEqualTo: true)
      .where('is_completed', isEqualTo: false)
      .where("status", isEqualTo: "ongoing")
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
                    return Container(
                      color: kPrimaryColor,
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: Column(
                        children: [
                          Text(
                            "Transaction information",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Service provider"),
                              Text(_transactionData["carrier"]),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Service"),
                              Text(_transactionData["service"]),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Amount to ${_transactionData["service"]}"),
                              Text(_transactionData["amount"]),
                            ],
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('transaction')
                                  .doc(_transactionData.id)
                                  .update({
                                'is_active': false,
                                'agent': FirebaseAuth.instance.currentUser!.uid
                              });

                              ttrips.doc(_transactionData.id).set({
                                'agent': FirebaseAuth.instance.currentUser!.uid,
                                'transaction': _transactionData.id,
                                "accepted_time": Timestamp.now(),
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TransactionOnMove(_transactionData.id),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(8),
                                backgroundColor: kSecondaryColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Accept ",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                                Icon(
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
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
