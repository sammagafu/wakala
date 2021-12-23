import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/model/banks.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/detailpage/withdraw/banks.dart';

class BanksWidget extends StatefulWidget {
  const BanksWidget({Key? key}) : super(key: key);

  @override
  _BanksWidgetState createState() => _BanksWidgetState();
}

class _BanksWidgetState extends State<BanksWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Banks",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        SizedBox(height: 18),
        Material(
          // borderRadius: BorderRadius.circular(10),
          color: kPrimaryColor,
          elevation: 2,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            height: 180,
            child: ListView.builder(
              // padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: banks.length,
              itemBuilder: (BuildContext context, int index) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WithdrawBank(banks[index]),
                      ));
                },
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundColor: kContentDarkTheme,
                        radius: 40,
                        backgroundImage: AssetImage(banks[index].url),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Text(
                        banks[index].name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
