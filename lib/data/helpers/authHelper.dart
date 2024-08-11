// ignore_for_file: unused_field, unused_local_variable, file_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class authHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  authHelper();

  Future<bool> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      var uid = _firebaseAuth.currentUser?.uid;
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyEmail() async {
    try {
      await _firebaseAuth.currentUser!.sendEmailVerification();
      return true;
    } catch (e) {
      rethrow;

    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
    rethrow;
    }
  }

  Future<String?> createUser(String mail, String pass) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: mail,
        password: pass,
      );
      if (userCredential.user == null) {
        return null;
      }
      return userCredential.user!.uid;
    } catch (e) {
     rethrow;
    }
  }

  Future<bool> deleteUser() async {
    try {
      await _firebaseAuth.currentUser!.delete();
      return true;
    } catch (e) {
     rethrow;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (oldPassword == newPassword) {
      return false;
    }
    try {
      User? userCredential = _firebaseAuth.currentUser;
      if (userCredential == null) {
        return false;
      }
      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: userCredential.email!, password: oldPassword);
        await userCredential.reauthenticateWithCredential(credential);
      } catch (e) {
        rethrow;
      }
      try {
        await _firebaseAuth.currentUser!.updatePassword(newPassword);
      } catch (e) {
        rethrow;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
