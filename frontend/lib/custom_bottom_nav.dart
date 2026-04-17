import 'package:flutter/material.dart';
import 'home_page.dart';
import 'explorPage.dart';
import 'passport_scan_page.dart';
import 'all_services_page.dart'; 
import 'profile.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFF8B2323);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) => _navigateToTab(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.badge_outlined), label: "Pass"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Services"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    if (index == currentIndex) return; 

    Widget page;
    switch (index) {
      case 0: page = const UserTypePage(); break;
      case 1: page = const ExploreScreen(); break;
      case 2: page = const PassportScanPage(); break;
      case 3: page = const ServicesScreen(); break;
      case 4: page = const ProfileScreen(); break;
      default: return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}