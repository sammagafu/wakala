import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/welcomescreen/landingscreen.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String default_language = 'English';
  var language = [
    'English',
    'Swahili',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 100),
            child: DropdownButton(
              value: default_language,
              elevation: 2,
              icon: const Icon(Icons.language),
              items: language.map((String language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: kPrimaryColor)),
                );
              }).toList(),
              onChanged: (value) {
                Navigator.pushNamed(context, LandingScreen.id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
