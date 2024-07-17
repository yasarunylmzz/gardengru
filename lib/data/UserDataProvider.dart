import 'dart:io';

import 'package:flutter/material.dart';
import 'dataModels/AuthModel.dart';
import 'dataModels/UserModel.dart';
import 'dataModels/UserDataModel.dart';
import 'dataModels/SavedModel.dart';

class UserDataProvider with ChangeNotifier {
  UserDataModel _userDataModel = UserDataModel();
  UserDataModel get userDataModel => _userDataModel;
  bool _ISLOGGED = false;

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

  void updateUserModel(
      String name, String surname) {
    _userDataModel.userModel = UserModel()
      ..Name = name
      ..Surname = surname;
    notifyListeners();
  }

  void updateUserDataModel(UserDataModel userDataModel) {
    _userDataModel = userDataModel;
    notifyListeners();
  }




  void login(){
    _ISLOGGED = true;
    notifyListeners();
  }
  void logout(){
    _ISLOGGED = false;
    notifyListeners();
  }

}
