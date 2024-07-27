import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gardengru/data/userRecordProvider.dart';
import 'package:gardengru/widgets/ProfileSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ManageAccountScreen.dart';
import '../main.dart';
import 'LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController(text: 'John Doe');
  TextEditingController _emailController = TextEditingController(text: 'john.doe@example.com');
  TextEditingController _phoneController = TextEditingController(text: '+1 234 567 8901');

  bool _isEditing = false;

  String getNameAndSurnameForHeader(BuildContext context) {
    final userProvider = Provider.of<userRecordProvider>(context);
    final user = userProvider.user;
    String name = user.Name ?? '';
    String surname = user.Surname ?? '';
    return '$name $surname';
  }

  void _handleLogout() async {
    FirebaseAuth.instance.signOut();
    RestartWidget.restartApp(context);
    print('User tapped Log Out');
  }

  void _navigateToManageAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageAccountScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.workSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getNameAndSurnameForHeader(context),
                          style: GoogleFonts.workSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.62,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileSettings(
                        name: 'My account',
                        description: 'Manage your account',
                        icon: Icons.arrow_forward_ios,
                        onTap: _navigateToManageAccount,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ProfileSettings(
                        name: 'Log Out',
                        description: 'Further secure your account for safety',
                        icon: Icons.arrow_forward_ios,
                        onTap: _handleLogout,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          'More',
                          style: GoogleFonts.workSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const ProfileSettings(
                        name: 'Help & Support',
                        description: 'Help center and legal support',
                        icon: Icons.arrow_forward_ios,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const ProfileSettings(
                        name: 'About App',
                        description: 'Learn more about the app',
                        icon: Icons.arrow_forward_ios,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
