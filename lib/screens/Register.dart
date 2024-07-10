import 'package:flutter/material.dart';
import 'package:gardengru/data/FireBaseAuthHelper.dart';
import 'package:gardengru/data/FireStoreHelper.dart';
import 'package:gardengru/data/dataModels/SavedModel.dart';
import 'package:gardengru/data/dataModels/UserDataModel.dart';
import 'package:gardengru/screens/TestScreen.dart';
import 'package:provider/provider.dart';
import 'package:gardengru/data/UserDataProvider.dart';
import 'package:gardengru/data/dataModels/AuthModel.dart';
import 'package:gardengru/data/dataModels/UserModel.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  FireBaseAuthHelper _authHelper = FireBaseAuthHelper();
  FireStoreHelper _storeHelper = FireStoreHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    UserDataModel? userDataModel = UserDataModel();
      AuthModel? authModel = await _authHelper.createUser(_emailController.text, _passwordController.text);

      userDataModel.authModel = authModel;

      if(authModel != null){
        userDataModel.userModel = UserModel()
        ..Name = _nameController.text
        ..Surname = _surnameController.text
          //it is not safe
        ..Age = int.parse(_ageController.text)
        ..Gender = _genderController.text
        ..savedModel = SavedModel()
        ..Country = _countryController.text;
        bool success = await _storeHelper.initNewUser(userDataModel);
            if(success)
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TestScreen()));
            }




      }





  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'İsim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen isminizi girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(labelText: 'Soyisim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen soyisminizi girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Cinsiyet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen cinsiyetinizi girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Yaş'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen yaşınızı girin';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Lütfen geçerli bir yaş girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Ülke'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ülkenizi girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
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
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifrenizi girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _register(context),
                child: Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
