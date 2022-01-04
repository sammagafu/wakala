import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/deposit.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/home.dart';
import 'package:wakala/screen/dashboard/userdashboard/tabs/withdraw.dart';

class UserDashboard extends StatefulWidget {
  static String id = 'users dashboard';
  const UserDashboard({Key? key}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
    int selectedIndex = 0;
    List<Widget> _widgetoption = [
      // Dashboard(),
      Home(),
      Deposit(),
      Withdraw(),
    ];

    void _onItemTap(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: kContentDarkTheme,
        showUnselectedLabels: true,
        fixedColor: kPrimaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_up),
            label: "Deposit",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_down),
            label: "Withdraw",
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTap,
      ),
      body: _widgetoption.elementAt(selectedIndex),
    );
  }
}
