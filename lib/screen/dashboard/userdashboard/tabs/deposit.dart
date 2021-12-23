import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/userdashboard/deposit/mno.dart';
import 'package:wakala/screen/dashboard/userdashboard/deposit/banks.dart';

class Deposit extends StatefulWidget {
  static String id = "deposit";
  const Deposit({Key? key}) : super(key: key);

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final _auth = FirebaseAuth.instance.currentUser;
  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('transaction');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Deposit",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Mno(),
              BanksWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
