import 'package:flutter/material.dart';
import 'package:gardengru/data/FireBaseAuthHelper.dart';
import 'package:gardengru/data/dataModels/UserDataModel.dart';
import 'package:gardengru/screens/BottomNavScreen.dart';
import 'package:gardengru/screens/Register.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gardengru/data/UserDataProvider.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FireBaseAuthHelper _fireBaseAuthHelper = FireBaseAuthHelper();
  String? _loginError;
  var passwordVisible = true;


//login and navigate to next page function
  Future<void> LoginAndNavigateToNextPage(context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    UserDataModel? userDataModel =
        await _fireBaseAuthHelper.InitUserDataModelForCurrentUser(
            email, password);

    if (userDataModel == null) {
      print("failed to login");
      return;
    }
    Provider.of<UserDataProvider>(context, listen: false)
        .setAuthModel(userDataModel.authModel!);
    Provider.of<UserDataProvider>(context, listen: false)
        .setUserModel(userDataModel.userModel!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Welcome Back!',
              style: GoogleFonts.workSans(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.workSans(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => LoginAndNavigateToNextPage(context),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
                  backgroundColor: const Color(0xff0098ff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.workSans(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_loginError != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _loginError!,
                    style: const TextStyle(color: Colors.red),
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
                        const Image(
                          image: NetworkImage(
                              'https://static-00.iconduck.com/assets.00/google-icon-2048x2048-pks9lbdv.png'),
                          width: 45,
                        ),
                        const SizedBox(width: 10),
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
                    'Don\'t have an account?',
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
                          builder: (context) => RegisterScreen(),
                          fullscreenDialog: false,
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.workSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff0098ff),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
