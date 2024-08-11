import 'package:flutter/material.dart';
import 'package:gardengru/data/helpers/authHelper.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:gardengru/data/userRecordProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;

  final authHelper _authHelper = authHelper();


  bool _isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? 'John');
    _surnameController = TextEditingController(text: 'Doe');
    _emailController =
        TextEditingController(text: user?.email ?? 'john.doe@example.com');
  }

  void _verifyEmail() async {
    await _authHelper.verifyEmail();
    setState(() {
      _isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });
  }

  void _deleteAccount() {
    _authHelper.deleteUser();
  }

  @override
  Widget build(BuildContext context) {
    final userRecord u = Provider.of<userRecordProvider>(context).user;
    _nameController.text = u.getname ?? 'John';
    _surnameController.text = u.getsurname ?? 'Doe';
    _emailController.text = u.getmail ?? 'john.doe@example.com';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Manage Your Account',
          style: GoogleFonts.workSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Surname',
                  prefixIcon: Icon(Icons.person_outline),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: _isEmailVerified
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : TextButton(
                          onPressed: _verifyEmail,
                          child: const Text('Verify'),
                        ),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Provider.of<userRecordProvider>(context, listen: false)
                      .updateUserRecord(
                    name: _nameController.text,
                    surname: _surnameController.text,
                    email: _emailController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
