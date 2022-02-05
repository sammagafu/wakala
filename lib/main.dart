import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wakala/screen/dashboard/admindashboard/agentdashboard.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/deposit.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/withdraw.dart';
import 'package:wakala/screen/dashboard/userdashboard/userdashboard.dart';
import 'package:wakala/screen/registration/registerAgent.dart';
import 'package:wakala/screen/welcomescreen/landingscreen.dart';
import 'package:wakala/screen/welcomescreen/language.dart';
import 'package:wakala/screen/welcomescreen/login.dart';
import 'package:wakala/theme/theme.dart';
import 'package:provider/provider.dart';

// import 'package:';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        StreamProvider.value(
            value: FirebaseAuth.instance.authStateChanges(),
            initialData: FirebaseAuth.instance.currentUser),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: wakalaTheme(),
      home: const Language(),
      routes: {
        LandingScreen.id: (context) => const LandingScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterUserAgent.id: (context) => RegisterUserAgent(),
        UserDashboard.id: (context) => const UserDashboard(),
        AgentDashboard.id: (context) => const AgentDashboard(),
        Withdraw.id: (context) => const Withdraw(),
        Deposit.id: (context) => const Deposit(),
      },
    );
  }
}
