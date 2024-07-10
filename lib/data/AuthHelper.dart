

import 'package:gardengru/data/FireBaseAuthHelper.dart';
import 'package:gardengru/data/dataModels/AuthModel.dart';
import 'package:gardengru/data/FireStoreHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper{

  FireBaseAuthHelper _FireBaseAuthHelper = FireBaseAuthHelper();


  AuthHelper();

  Future<bool>isAuthSucces(String? mail, String? pass) async{
    return (await _FireBaseAuthHelper.tryLogin(mail, pass)) != null;
  }





}