import 'package:gardengru/data/dataModels/AuthModel.dart';
import 'package:gardengru/data/dataModels/UserModel.dart';

class UserDataModel {
  AuthModel? _authModel;
  UserModel? _userModel;

  AuthModel? get authModel => _authModel;
  UserModel? get userModel => _userModel;

  set authModel(AuthModel? authModel) {
    _authModel = authModel;
  }

  set userModel(UserModel? userModel) {
    _userModel = userModel;
  }
}
