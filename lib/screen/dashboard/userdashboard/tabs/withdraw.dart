import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/userdashboard/deposit/mno.dart';
import 'package:wakala/screen/dashboard/userdashboard/deposit/banks.dart';

class Withdraw extends StatefulWidget {
  static String id = "withdraw";
  const Withdraw({Key? key}) : super(key: key);

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 65, 15, 30),
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Withdraw",
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: kPrimaryColor),
            ),
          ),
          Mno(),
          BanksWidget(),
        ],
      ),
    );
  }
}
