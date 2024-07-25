import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gardengru/data/helpers/authHelper.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:gardengru/screens/LoginScreen.dart';
import '../data/helpers/FireStoreHelper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final authHelper _authHelper = authHelper();
  final FireStoreHelper _storeHelper = FireStoreHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController = TextEditingController();

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
        MaterialPageRoute(
            builder: (context) => LoginScreen()),
      );
    }
  }

  var passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 8, right: 8, top: 50),
          children: [
            Column(
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.people_outline),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen isminizi girin';
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
                  return 'Lütfen soyisminizi girin';
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
                  return 'Lütfen email adresinizi girin';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outlined),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  icon: Icon(Icons.remove_red_eye_outlined),
                ),
              ),
              obscureText: passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen şifrenizi girin';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _confirmedPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmed Password',
                prefixIcon: Icon(Icons.lock_outlined),
                border: InputBorder.none,
              ),
              obscureText: passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen şifrenizi girin';
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
              child: Text(
                'Sign Up',
                style: GoogleFonts.workSans(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
                backgroundColor: const Color(0xff4cb254),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 12,
                      endIndent: 12,
                    ),
                  ),
                  Text('Or'),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 12,
                      endIndent: 12,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(80),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: NetworkImage(
                            'https://static-00.iconduck.com/assets.00/google-icon-2048x2048-pks9lbdv.png'),
                        width: 45,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Sign Up With Google',
                        style: GoogleFonts.workSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
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
                            builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    'Log In',
                    style: GoogleFonts.workSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4cb254),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
