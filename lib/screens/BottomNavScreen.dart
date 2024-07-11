import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gardengru/screens/CameraScreen.dart';
import 'package:gardengru/screens/HomeScreen.dart';
import 'package:gardengru/screens/ProfileScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentPageIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const CameraScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[currentPageIndex],
      bottomNavigationBar: FloatingNavbar(
        width: MediaQuery.of(context).size.width * .9,
        margin: EdgeInsets.only(bottom: 0),
        iconSize: 24,
        selectedItemColor: Colors.green,
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: [
          FloatingNavbarItem(
            icon: Icons.home,
          ),
          FloatingNavbarItem(
            icon: Icons.camera_alt,
          ),
          FloatingNavbarItem(
            icon: Icons.person,
          ),
        ],
      ),
    );
  }
}
