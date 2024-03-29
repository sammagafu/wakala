import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/userdashboard/sucesstransfer.dart';

class WithdrawDetail extends StatefulWidget {
  final mno;
  const WithdrawDetail(this.mno);
  @override
  _WithdrawDetailState createState() => _WithdrawDetailState();
}

class _WithdrawDetailState extends State<WithdrawDetail> {
  final _auth = FirebaseAuth.instance.currentUser;
  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('transaction');
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final mno = ModalRoute.of(context)!.settings.arguments as Mno;

    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: Text("Withdraw ${widget.mno.name} Agent".toLowerCase()),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(15, 45, 15, 80),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.money,
                      color: kContentDarkTheme,
                    ),
                    labelText: "Enter amount",
                    labelStyle: TextStyle(color: kContentDarkTheme),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kContentDarkTheme,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Amount");
                    }
                    if (value.length > 6) {}
                  },
                ),
                const SizedBox(height: 24),
                const Text("The maximum withdraw is TZS 100,000"),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Complete withdraw"),
                    NeumorphicButton(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(25),
                      onPressed: withdraw,
                      style: const NeumorphicStyle(
                        lightSource: LightSource.topLeft,
                        shape: NeumorphicShape.flat,
                        boxShape: const NeumorphicBoxShape.circle(),
                        color: kPrimaryColor,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: kContentDarkTheme,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> withdraw() async {
    final formState = _formKey.currentState;
    bool serviceEnabled;
    LocationPermission permission;

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

    if (formState!.validate()) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return _transaction
          .add({
            "amount": amountController.text,
            "carrier": widget.mno.name,
            "is_active": true,
            "is_completed": false,
            "request_time": DateTime.now(),
            "service": "withdraw",
            "user": _auth!.uid,
            "status": "started",
            "users_location": GeoPoint(position.latitude, position.longitude)
          })
          .then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => SuccessScreen(value.id))))
          .catchError((error) => print("Failed to add user: $error"));
    }
  }
}
