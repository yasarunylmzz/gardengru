

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gardengru/data/FireStoreHelper.dart';
import 'package:gardengru/data/dataModels/UserDataModel.dart';
import 'dataModels/AuthModel.dart';

class FireBaseAuthHelper {

  FireBaseAuthHelper();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FireStoreHelper _FireStoreHelper = FireStoreHelper();



  Future<UserDataModel?> InitUserDataModelForCurrentUser(String? mail, String? pass) async
  {
      UserDataModel userDataModel = UserDataModel();
      AuthModel? authModel = await GetUserLoginInfo(mail, pass);
      if (authModel == null)
      { return null; }
      userDataModel.authModel = authModel;
      try
      {
      userDataModel.userModel = await _FireStoreHelper.GetUserDataFromDatabaseWithId(authModel.uid!);
      print("JUSTFINDME" + (userDataModel.userModel?.savedModels != null &&
          userDataModel.userModel!.savedModels!.isNotEmpty &&
          userDataModel.userModel!.savedModels![0].createdAt != null
          ? userDataModel.userModel!.savedModels![0].createdAt.toString()
          : 'No Date'));

      if(userDataModel.userModel == null)
      {
        return null;
      }

      return userDataModel;
      } catch (e) {
        print('Error during login: $e');
        return null; //
    }
  }





  Future<AuthModel?> GetUserLoginInfo(String? mail, String? pass) async {
    //regex ile kontrol ?
    if (mail == null || pass == null)
    {
      return null;
    }
      try
      {
              UserCredential userCredential = await _firebaseAuth!
                  .signInWithEmailAndPassword(
                email: mail,
                password: pass,);
        String? uid = userCredential.user?.uid;
        AuthModel authModel = AuthModel()
          ..uid = uid
          ..mail = mail;
        return authModel;
      }
        catch (e)
      {
        print('Error during login: $e');
        return null;
      }
    }



  Future<AuthModel?> createUser(String mail, String pass) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: mail,
        password: pass,
      );

      User? user = userCredential.user;
      if (user != null) {
        return AuthModel()
          ..uid = user.uid
          ..mail = user.email
          ..pass = pass;  // Not hashed, for demonstration purposes only
      }
      return null;
    } catch (e) {
      print("Error creating user: $e");
      return null;
    }
  }
}



