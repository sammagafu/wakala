import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/detailpage/deposit/banks.dart';
import 'package:wakala/servicesProvided/banks.dart';

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
        const SizedBox(height: 45),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Banks",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: kPrimaryColor),
          ),
        ),
        const SizedBox(height: 18),
        Material(
          borderRadius: BorderRadius.circular(10),
          color: kContentColorLightTheme,
          elevation: 7,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            height: 170,
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
                      padding: const EdgeInsets.all(12),
                      child: CircleAvatar(
                        backgroundColor: kContentDarkTheme,
                        radius: 40,
                        backgroundImage: AssetImage(banks[index].url),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        banks[index].name,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: kContentDarkTheme),
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
