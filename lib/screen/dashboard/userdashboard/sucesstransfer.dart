import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/message.dart';
import 'package:wakala/screen/dashboard/userdashboard/userdashboard.dart';

class SuccessScreen extends StatefulWidget {
  final data;

  const SuccessScreen(this.data);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  PageController controller = PageController();
  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('transaction');
  double rating = 0;
  Future<void> cancelTransaction() {
    return _transaction
        .doc(widget.data)
        .update({
          'is_active': false,
          'is_completed': false,
          'status': 'cancelled',
        })
        .then((value) => print("Trip Cancelled"))
        .catchError((error) => print("Trip Cancelled: $error"));
  }

  final CollectionReference ttrips =
      FirebaseFirestore.instance.collection("transaction_trips");
  final chargers = 0;
  showWithdrawrates(amount) {
    if (amount < 20000) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Charges",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "3000",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Withraw Charges",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "3000",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ],
      );
    }
    if (amount > 20000 && amount < 50000) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Withdraw Charges",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            "5000",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Withdraw Charges",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            "6000",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );
    }
  }

  showDepositrates(amount) {
    if (amount < 20000) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Deposit Charges",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            "2000",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );
    }
    if (amount > 20000 && amount < 50000) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Deposit Charges",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            "3000",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Deposit Charges",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            "4000",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.8,
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return StreamBuilder(
                stream: _transaction.doc(widget.data).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.data!["status"] == "completed") {
                    return Container(
                      color: kPrimaryColor,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 45),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          const Icon(
                            Icons.mood,
                            size: 80,
                            color: kContentDarkTheme,
                          ),
                          const Text(
                            "Thanks for choosing us, Please rate the service",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 42),
                          SmoothStarRating(
                              size: 40,
                              rating: rating,
                              halfFilledIconData: Icons.star_half,
                              filledIconData: Icons.star,
                              defaultIconData: Icons.star_border,
                              starCount: 5,
                              borderColor: kWarningColor,
                              color: kWarningColor,
                              allowHalfRating: false,
                              spacing: 2.0,
                              onRatingChanged: (value) {
                                setState(() {
                                  rating = value;
                                });
                              }),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, UserDashboard.id);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Go back"),
                                SizedBox(
                                  width: 24,
                                ),
                                Icon(Icons.cancel)
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.data!["status"] == "ongoing") {
                    var amount = snapshot.data!["amount"];
                    return Container(
                      color: kPrimaryColor,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 45),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          const Text("Ongoing transaction"),
                          const SizedBox(height: 12),
                          Container(
                            height: 1,
                            width: 100,
                            color: kContentDarkTheme,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Service",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                snapshot.data!["service"],
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Carrier",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                snapshot.data!["carrier"],
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                snapshot.data!["amount"],
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          ),
                          const SizedBox(height: 24),
                          StreamBuilder(
                            stream: ttrips.doc(widget.data).snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Connecting to nearby agent'),
                                    CircularProgressIndicator(),
                                  ],
                                );
                              }
                              var userprofile = snapshot.data['agent'];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Message(widget.data)));
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: kContentDarkTheme,
                                      radius: 25,
                                      child: Icon(
                                        Icons.message,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('user_profile')
                                          .where('uiid', isEqualTo: userprofile)
                                          .limit(1)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        }
                                        var phonenumber =
                                            snapshot.data!.docs.first;
                                        return GestureDetector(
                                          onTap: () {
                                            launch(
                                                "tel:${phonenumber['phone_number']}");
                                          },
                                          child: const CircleAvatar(
                                            backgroundColor: kContentDarkTheme,
                                            radius: 25,
                                            child: Icon(
                                              Icons.phone,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          const Text("Charges"),
                          const SizedBox(height: 12),
                          Container(
                            height: 1,
                            width: 100,
                            color: kContentDarkTheme,
                          ),
                          const SizedBox(height: 24),
                          snapshot.data!["service"] == "withdraw"
                              ? showWithdrawrates(
                                  double.parse(snapshot.data!["amount"]))
                              : showDepositrates(
                                  double.parse(snapshot.data!["amount"])),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  }
                  return Container(
                    color: kPrimaryColor,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        const Text("Transaction Details"),
                        const SizedBox(height: 12),
                        Container(
                          height: 1,
                          width: 100,
                          color: kContentDarkTheme,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              snapshot.data!["service"],
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Carrier",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              snapshot.data!["carrier"],
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              snapshot.data!["amount"],
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text("Charges"),
                        const SizedBox(height: 12),
                        Container(
                          height: 1,
                          width: 100,
                          color: kContentDarkTheme,
                        ),
                        const SizedBox(height: 24),
                        snapshot.data!["service"] == "withdraw"
                            ? showWithdrawrates(
                                double.parse(snapshot.data!["amount"]))
                            : showDepositrates(
                                double.parse(snapshot.data!["amount"])),
                        const SizedBox(height: 24),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              backgroundColor: kSecondaryColor),
                          onPressed: () {
                            cancelTransaction();
                            Navigator.pop(context, UserDashboard.id);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Cancell Transaction",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                              const Icon(
                                Icons.cancel,
                                color: kContentDarkTheme,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
