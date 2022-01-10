import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakala/screen/dashboard/admindashboard/agentdashboard.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/message.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/deposit.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/withdraw.dart';
import 'package:wakala/screen/dashboard/userdashboard/userdashboard.dart';
import 'package:wakala/screen/registration/registerAgent.dart';
import 'package:wakala/screen/registration/registerClient.dart';
import 'package:wakala/screen/welcomescreen/createaccount.dart';
import 'package:wakala/screen/welcomescreen/landingscreen.dart';
import 'package:wakala/screen/welcomescreen/login.dart';
import 'package:wakala/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: wakalaTheme(),
      home: const LandingScreen(),
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        CreateAccount.id: (context) => const CreateAccount(),
        RegisterUserAgent.id: (context) => RegisterUserAgent(),
        RegisterUserClient.id: (context) => const RegisterUserClient(),
        UserDashboard.id: (context) => const UserDashboard(),
        AgentDashboard.id: (context) => const AgentDashboard(),
        Withdraw.id: (context) => const Withdraw(),
        Deposit.id: (context) => const Deposit(),
      },
    );
  }
}
