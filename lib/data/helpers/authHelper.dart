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
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> verifyEmail() async {
    try {
      await _firebaseAuth.currentUser!.sendEmailVerification();
      return true;
    } catch (e) {
      print('Error during email verification: $e');
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Error during password reset: $e');
      return false;
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
      print("Error creating user: $e");
      return null;
    }
  }

  Future<bool> deleteUser() async {
    try {
      await _firebaseAuth.currentUser!.delete();
      return true;
    } catch (e) {
      print("Error deleting user: $e");
      return false;
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
        print("Error reauthenticating user: $e");
        return false;
      }
      try {
        await _firebaseAuth.currentUser!.updatePassword(newPassword);
      } catch (e) {
        print("Error updating password: $e");
        return false;
      }
      return true;
    } catch (e) {
      print("Error changing password: $e");
      return false;
    }
  }
}
