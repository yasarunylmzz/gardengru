import 'package:flutter/material.dart';
import 'package:gardengru/screens/CameraScreen.dart';
import 'package:gardengru/screens/HomeScreen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentPageIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    PlaceholderWidget(), // Kameranın yerini Placeholder ile dolduruyoruz
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );
    } else {
      setState(() {
        currentPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.camera_alt_rounded),
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Kamera',
          ),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Bu ekran şu anda boş.'),
    );
  }
}
