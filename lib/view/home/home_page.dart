import 'package:flutter/material.dart';
import 'package:outdo_app/util/colors.dart';
import 'package:outdo_app/view/delivery_management_screen.dart';
import 'package:outdo_app/view/projects_screen.dart';
import 'package:outdo_app/view/vendor_screen.dart';
import 'package:outdo_app/view/site_measurement_screen.dart';

import '../meetings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  // ignore: prefer_final_fields
  List<Widget> _screens = [
    MettingsScreen(),
    SiteMeasurementScreen(),
    ProjectsScreen(),
    DeliveryManagementScreen(),
    VendorScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() {
            selectedIndex = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                  radius: 23,
                  backgroundColor: Appcolors.blue,
                  child: Icon(Icons.add, color: Appcolors.white)),
              label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.wallet_giftcard), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.car_crash_outlined), label: ''),
        ],
        backgroundColor: Appcolors.white,
        iconSize: 30.0,
        selectedItemColor: Appcolors.blue,
        unselectedItemColor: Appcolors.black,
      ),
    );
  }
}
