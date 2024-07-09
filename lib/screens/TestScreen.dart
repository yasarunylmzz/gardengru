import 'package:flutter/material.dart';
import 'package:gardengru/data/FireStoreHelper.dart';
import 'package:gardengru/data/dataModels/AuthModel.dart';
import 'package:gardengru/data/FireBaseAuthHelper.dart';

class TestScreen extends StatefulWidget {
  TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  final FireStoreHelper _fireStoreHelper = FireStoreHelper();
  final FireBaseAuthHelper _authHelper = FireBaseAuthHelper();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _loginError;

  Future<void> _tryLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _loginError = 'Email and password cannot be empty.';
      });
      return;
    }

    AuthModel authModel = AuthModel('', email, password);
    AuthModel result = await _authHelper.tryLogin(authModel);

    if (result.uid != null && result.uid!.isNotEmpty) {
      setState(() {
        _loginError = null;
      });
      print('User authenticated: UID: ${result.uid}, Email: ${result.mail}');
    } else {
      setState(() {
        _loginError = 'Authentication failed. Please check your email and password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ),
          ElevatedButton(
            onPressed: _tryLogin,
            child: Text('Login'),
          ),
          if (_loginError != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _loginError!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _fireStoreHelper.getDocuments(
                'data', // Buraya koleksiyon adınızı girin
                    (data, documentId) => documentId, // Sadece documentId'yi döndür
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index]), // Document ID'yi göster
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
