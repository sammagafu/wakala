import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';

ThemeData wakalaTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: kPrimaryColor,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headline2: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        fontSize: 34,
      ),
      headline3: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
      bodyText1: TextStyle(
        fontFamily: "Poppins",
        fontSize: 18,
      ),
      bodyText2: TextStyle(
        fontFamily: "Poppins",
        color: kContentDarkTheme,
        fontSize: 16,
      ),
      headline5: TextStyle(
        fontFamily: "Poppins",
        color: kContentDarkTheme,
        fontSize: 18,
      ),
      headline6: TextStyle(
        fontFamily: "Poppins",
        color: kContentDarkTheme,
        // fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
    canvasColor: kContentColorLightTheme,
    // primaryColor: Colors.red,
  );
}
