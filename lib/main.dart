import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wakala/screen/dashboard/admindashboard/agentdashboard.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/message.dart';
import 'package:wakala/screen/dashboard/userdashboard/userdashboard.dart';
import 'package:wakala/screen/registration/registerAgent.dart';
import 'package:wakala/screen/registration/registerClient.dart';
import 'package:wakala/screen/welcomescreen/createaccount.dart';
import 'package:wakala/screen/welcomescreen/landingscreen.dart';
import 'package:wakala/screen/welcomescreen/login.dart';
import 'package:wakala/theme/theme.dart';
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: wakalaTheme(),
      home: LandingScreen(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        CreateAccount.id: (context) => CreateAccount(),
        RegisterUserAgent.id: (Context) => RegisterUserAgent(),
        RegisterUserClient.id: (Context) => RegisterUserClient(),
        UserDashboard.id: (Context) => UserDashboard(),
        AgentDashboard.id: (Context) => AgentDashboard(),
      },
    );
  }
}
