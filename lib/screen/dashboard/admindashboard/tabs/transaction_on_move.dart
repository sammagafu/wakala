import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wakala/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakala/screen/dashboard/admindashboard/agentdashboard.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/message.dart';

class TransactionOnMove extends StatefulWidget {
  static final String id = "transaction on move";
  final data;

  const TransactionOnMove(this.data);

  @override
  _TransactionOnMoveState createState() => _TransactionOnMoveState();
}

class _TransactionOnMoveState extends State<TransactionOnMove> {
  final _transaction = FirebaseFirestore.instance.collection('transaction');
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

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _determinePosition(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: .5,
                    child: GoogleMap(
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            snapshot.data.latitude, snapshot.data.longitude),
                        zoom: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 75, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          launch("tel:+255788419991");
                        },
                        child: const CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          radius: 25,
                          child: Icon(
                            Icons.phone,
                            color: kContentDarkTheme,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Message(widget.data)));
                        },
                        child: const CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          radius: 25,
                          child: Icon(
                            Icons.message,
                            color: kContentDarkTheme,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: EdgeInsets.fromLTRB(24, 16, 24, 16)),
                        onPressed: () {
                          _transaction.doc(widget.data).update({
                            "is_completed": true,
                            "is_active": false,
                          });
                          Navigator.pushNamed(context, AgentDashboard.id);
                        },
                        child: Text(
                          "Finish Transaction",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      )),
                ),
              ],
            );
          } else {
            return Container(
              color: kPrimaryColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
