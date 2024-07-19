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
  void addSavedModel(SavedModel savedModel) {
    _userDataModel.userModel?.savedModels?.add(savedModel);
    notifyListeners();
  }

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
      String name, String surname,List<SavedModel> SavedModels) {
    _userDataModel.userModel = UserModel()
      ..Name = name
      ..Surname = surname
      ..savedModels = SavedModels;
    notifyListeners();
  }

  void updateUserDataModel(UserDataModel userDataModel) {
    _userDataModel = userDataModel;
    notifyListeners();
  }

  void updateSavedModels(List<SavedModel> savedModels) {
    _userDataModel.userModel!.savedModels = savedModels;
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
