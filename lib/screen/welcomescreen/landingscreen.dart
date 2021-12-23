import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/welcomescreen/createaccount.dart';
import 'package:wakala/screen/welcomescreen/login.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);
  final String logo = 'assets/images/logo.svg';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 1,
            child: Image.asset(
              'assets/images/onboarding.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 135, 20, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                logo,
                height: 85.0,
                color: kContentDarkTheme,
              ),
              SizedBox(
                height: 45,
              ),
              Text(
                "Connects you to the nearby mobile agent",
                style: Theme.of(context).textTheme.headline3,
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, CreateAccount.id);
                },
                style: TextButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  padding: EdgeInsets.all(20),
                ),
                child: Row(
                  children: [
                    Text(
                      "Creeate an account",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: kContentDarkTheme,
                      size: 16,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    side: BorderSide(color: Colors.white)),
                child: Row(
                  children: [
                    Text(
                      "Login",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: kContentDarkTheme,
                      size: 16,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "This app does not do any transaction",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        )
      ],
    );
  }
}
