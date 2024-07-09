

import 'package:gardengru/data/FireBaseAuthHelper.dart';
import 'package:gardengru/data/dataModels/AuthModel.dart';
import 'package:gardengru/data/FireStoreHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper{
  AuthModel? _AuthModel;
  FireBaseAuthHelper _FireBaseAuthHelper = FireBaseAuthHelper();


  AuthHelper(this._AuthModel);

  Future<bool>isAuthSucces(AuthModel _AuthModel) async{
    _AuthModel = await _FireBaseAuthHelper.tryLogin(_AuthModel);
    if(_AuthModel.uid != ''){
      return true;

    }
    else{
        return false;
    }

  }





}