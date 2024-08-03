import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gardengru/screens/CameraScreen.dart';
import 'package:gardengru/screens/HomeScreen.dart';
import 'package:gardengru/screens/ListSavedItems.dart';
import 'package:gardengru/screens/ProfileScreen.dart';

import '../data/navigationProvider.dart';

class BottomNavScreen extends StatefulWidget {
  final int initialPageIndex;

  const BottomNavScreen({this.initialPageIndex = 0, Key? key})
      : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
  }

  final List<Widget> _pages = const [
    HomeScreen(),
    CameraScreen(),
    ProfileScreen(),
    ListSavedItems(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Consumer<NavigationProvider>(
        builder: (context, provider, child) {
          return _pages[provider.currentPageIndex];
        },
      ),
      bottomNavigationBar: Consumer<NavigationProvider>(
        builder: (context, provider, child) {
          return FloatingNavbar(
            width: MediaQuery.of(context).size.width * .9,
            margin: const EdgeInsets.only(bottom: 0),
            iconSize: 24,
            selectedItemColor: Colors.green,
            currentIndex: provider.currentPageIndex,
            onTap: (index) {
              provider.setPageIndex(index);
            },
            items: [
              FloatingNavbarItem(icon: Icons.home),
              FloatingNavbarItem(icon: Icons.camera_alt),
              FloatingNavbarItem(icon: Icons.person),
              FloatingNavbarItem(icon: Icons.bookmark),
            ],
          );
        },
      ),
    );
  }
}
