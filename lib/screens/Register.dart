import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gardengru/data/helpers/authHelper.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:gardengru/screens/LoginScreen.dart';
import '../data/helpers/FireStoreHelper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final authHelper _authHelper = authHelper();
  final FireStoreHelper _storeHelper = FireStoreHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();

  Future<void> _register() async {
    userRecord u = userRecord(
        mail: _emailController.text,
        pass: _passwordController.text,
        Name: _nameController.text,
        Surname: _surnameController.text);

    String? uid = await _authHelper.createUser(u.mail!, u.pass!);
    if (uid != null) {
      u.uid = uid;
      _storeHelper.initNewUser(u);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  var passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 50),
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Get Started Now',
                    style: GoogleFonts.workSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('Create an account to continue',
                      style: GoogleFonts.workSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.people_outline),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Surname',
                  prefixIcon: Icon(Icons.people_outline),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                ),
                obscureText: passwordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmedPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmed Password',
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: InputBorder.none,
                ),
                obscureText: passwordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {_register()}
                  else
                    {print('validation failed')}
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
                  backgroundColor: const Color(0xff4cb254),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.workSans(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.workSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      'Log In',
                      style: GoogleFonts.workSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff4cb254),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
