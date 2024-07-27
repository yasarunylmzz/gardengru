import 'package:firebase_core/firebase_core.dart';
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
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final authHelper _authHelper = authHelper();

  bool _isEditing = false;
  bool _isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values
    final user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? 'John');
    _surnameController = TextEditingController(text: 'Doe');
    _emailController = TextEditingController(text: user?.email ?? 'john.doe@example.com');
  }

  void _verifyEmail() {
    _authHelper.verifyEmail();
    // Logic to send verification email
  }

  void _changePassword() {
    _authHelper.changePassword(_currentPasswordController.text, _newPasswordController.text);
    // Logic to change password
  }

  void _deleteAccount() {
    _authHelper.deleteUser();
    // Logic to delete account
  }

  @override
  Widget build(BuildContext context) {
    final userRecord u = Provider.of<userRecordProvider>(context).user;
    _nameController.text = u.getname ?? 'John';
    _surnameController.text = u.getsurname ?? 'Doe';
    _emailController.text = u.getmail ?? 'john.doe@example.com';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Account',
          style: GoogleFonts.workSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _surnameController,
                      decoration: InputDecoration(
                        labelText: 'Surname',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isEditing ? Icons.check : Icons.edit),
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  suffixIcon: _isEmailVerified
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : TextButton(
                    onPressed: _verifyEmail,
                    child: Text('Verify'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: Text(
                  'Change Password',
                  style: GoogleFonts.workSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              if (_isEditing) ...[
                TextField(
                  controller: _currentPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _changePassword,
                  child: Text('Update Password'),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('Delete Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
