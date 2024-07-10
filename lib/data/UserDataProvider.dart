import 'package:flutter/material.dart';
import 'dataModels/AuthModel.dart';
import 'dataModels/UserModel.dart';
import 'dataModels/UserDataModel.dart';

class UserDataProvider with ChangeNotifier {
  UserDataModel _userDataModel = UserDataModel();

  UserDataModel get userDataModel => _userDataModel;

  void setAuthModel(AuthModel authModel) {
    _userDataModel.authModel = authModel;
    notifyListeners();
  }

  void setUserModel(UserModel userModel) {
    _userDataModel.userModel = userModel;
    notifyListeners();
  }

  void updateAuthModel(String uid, String mail, String pass) {
    _userDataModel.authModel = AuthModel()
      ..uid = uid
      ..mail = mail
      ..pass = pass;
    notifyListeners();
  }

  void updateUserModel(String name, String surname, String gender, int age, String country) {
    _userDataModel.userModel = UserModel()
      ..Name = name
      ..Surname = surname
      ..Gender = gender
      ..Age = age
      ..Country = country;
    notifyListeners();
  }
}
