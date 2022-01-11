import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      body: StreamBuilder(
          stream: _transaction.doc(widget.data.toString()).snapshots(),
          builder: (BuildContext builder, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var user_ = snapshot.data['user'];
              double latitude = snapshot.data['users_location'].latitude;
              double longitude = snapshot.data['users_location'].longitude;
              return Stack(
                children: [
                  FutureBuilder(
                      future: _determinePosition(),
                      builder: (BuildContext builder, AsyncSnapshot snapshot) {
                        double distanceInMeters = Geolocator.distanceBetween(
                            latitude,
                            longitude,
                            snapshot.data.latitude,
                            snapshot.data.longitude);
                        print("the distance between is $distanceInMeters");
                        final Marker _clientsLocation = Marker(
                            markerId: MarkerId('_clientlocation'),
                            infoWindow: InfoWindow(title: "Client's location"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue),
                            position: LatLng(latitude, longitude));
                        final Marker _myLocation = Marker(
                            markerId: MarkerId('_mylocation'),
                            infoWindow: InfoWindow(title: "My Location"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue),
                            position: LatLng(snapshot.data.latitude,
                                snapshot.data.longitude));
                        return Positioned.fill(
                          child: Opacity(
                            opacity: .9,
                            child: GoogleMap(
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: true,
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(latitude, longitude),
                                tilt: 59.440717697143555,
                                zoom: 16,
                              ),
                              markers: {_clientsLocation, _myLocation},
                            ),
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("user_profile")
                                .where('uiid', isEqualTo: user_)
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                var _phone = snapshot.data!.docs.first;
                                return GestureDetector(
                                  onTap: () {
                                    launch("tel:${_phone['phone_number']}");
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: kPrimaryColor,
                                    radius: 25,
                                    child: Icon(
                                      Icons.phone,
                                      color: kContentDarkTheme,
                                    ),
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Message(widget.data)));
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
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 50),
                    child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              padding:
                                  const EdgeInsets.fromLTRB(24, 16, 24, 16)),
                          onPressed: () {
                            _transaction.doc(widget.data).update({
                              "is_completed": true,
                              "is_active": false,
                              "status": "completed"
                            });
                            Navigator.pushNamed(context, AgentDashboard.id);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Finish Transaction",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              const Icon(
                                Icons.assignment_turned_in_rounded,
                                color: kContentDarkTheme,
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              );
            } else {
              return const Text("An error happed");
            }
          }),
    );
  }
}
