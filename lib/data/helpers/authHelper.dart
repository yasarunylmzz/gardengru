

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/records/savedItemsRecord.dart';
import 'package:gardengru/data/userRecordProvider.dart';
import 'package:provider/provider.dart';

import '../dataModels/UserModelDto.dart';
import '../records/userRecord.dart';

class authHelper{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  authHelper();

  Future<bool> signIn(String email, String password) async
  {
    try
    {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      var uid = _firebaseAuth.currentUser?.uid;
      return true;
    } catch (e)
    {
      print('Error during login: $e');
      return false;
    }
  }


  Future<bool> resetPassword(String email) async
  {
    try
    {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e)
    {
      print('Error during password reset: $e');
      return false;
    }
  }


  Future<String?> createUser(String mail, String pass) async {
    try {
        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: mail,
        password: pass,
      );
      if(userCredential.user == null)
      {
        return null;
      }
      return userCredential.user!.uid;
    } catch (e) {
      print("Error creating user: $e");
      return null;
    }
  }

}




