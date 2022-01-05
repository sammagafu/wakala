import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/message.dart';
import 'package:wakala/screen/dashboard/userdashboard/userdashboard.dart';

enum TransactionStatus { Cancelled, Ongoing, Finished }

class SuccessScreen extends StatefulWidget {
  final data;
  const SuccessScreen(this.data);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  PageController controller = PageController();

  double _latitude = 0;
  double _longitude = 0;
  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('transaction');

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, 49.085749655962),
    zoom: 11,
  );
  Completer<GoogleMapController> _controller = Completer();

  Future<Position> getMyLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

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

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      body: Stack(
        children: [
          // Expanded(
          //   child: GoogleMap(
          //     myLocationButtonEnabled: false,
          //     zoomControlsEnabled: false,
          //     mapType: MapType.normal,
          //     initialCameraPosition: _kGooglePlex,
          //     onMapCreated: (GoogleMapController controller) {
          //       _controller.complete(controller);
          //     },
          //   ),
          // ),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 0.6,
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return StreamBuilder(
                stream: _transaction.doc(widget.data).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  return Container(
                    color: kPrimaryColor,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        Text("Transaction Details"),
                        SizedBox(height: 12),
                        Container(
                          height: 1,
                          width: 100,
                          color: kContentDarkTheme,
                        ),
                        SizedBox(height: 12),
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
                        SizedBox(height: 12),
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
                        SizedBox(height: 12),
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
                        SizedBox(height: 24),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Message(widget.data)));
                                  },
                                  child: CircleAvatar(
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
                                        return CircularProgressIndicator();
                                      }
                                      var phonenumber =
                                          snapshot.data!.docs.first;
                                      return GestureDetector(
                                        onTap: () {
                                          print(phonenumber['phone_number']);
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
                        SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(10),
                          ),
                          onPressed: () {
                            cancelTransaction();
                            Navigator.pop(context, UserDashboard.id);
                          },
                          child: Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Cancell Transaction"),
                                SizedBox(
                                  width: 24,
                                ),
                                Icon(Icons.cancel)
                              ],
                            ),
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
