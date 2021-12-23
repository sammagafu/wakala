import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/model/mno.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/detailpage/deposit/mno.dart';

class Mno extends StatefulWidget {
  const Mno({Key? key}) : super(key: key);

  @override
  _MnoState createState() => _MnoState();
}

class _MnoState extends State<Mno> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Mobile Network Operators",
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
              itemCount: mno.length,
              itemBuilder: (BuildContext context, int index) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WithdrawDetail(mno[index]),
                      ));
                },
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundColor: kContentDarkTheme,
                        radius: 40,
                        backgroundImage: AssetImage(mno[index].url),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Text(
                        mno[index].name,
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
