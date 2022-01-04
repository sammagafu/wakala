import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/activities.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/admin_dashboard.dart';
import 'package:wakala/screen/dashboard/admindashboard/tabs/setting.dart';

class AgentDashboard extends StatefulWidget {
  static String id = 'agent dashboard';
  const AgentDashboard({Key? key}) : super(key: key);

  @override
  _AgentDashboardState createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> {
  int selectedIndex = 0;
  List<Widget> _widgetoption = [
    AdminDashboard(),
    AdminActivities(),
    AdminSettings()
  ];

  void _onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
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
            icon: Icon(Icons.access_time),
            label: "Activities",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTap,
      ),
      body: _widgetoption.elementAt(selectedIndex),
    );
  }
}
