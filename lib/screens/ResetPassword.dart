import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gardengru/data/helpers/authHelper.dart'; // Ensure you have the correct import path

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final authHelper _fireBaseAuthHelper = authHelper();

  String? _resetError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: GoogleFonts.workSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Reset Your Password',
              style: GoogleFonts.workSans(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: InputBorder.none,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              _fireBaseAuthHelper
                  .resetPassword(_emailController.text)
                  .then((value) {
                if (value) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    _resetError = 'Failed to send reset email.';
                  });
                }
              })
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
              backgroundColor: const Color(0xff4cb254),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              ),
            ),
            child: Text(
              'Reset Password',
              style: GoogleFonts.workSans(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_resetError != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _resetError!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back to Login',
              style: GoogleFonts.workSans(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
