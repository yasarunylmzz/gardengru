import 'package:firebase_auth/firebase_auth.dart';
import 'dataModels/AuthModel.dart';

class FireBaseAuthHelper {

  FireBaseAuthHelper();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> tryLogin(String? mail, String? pass) async {
    //regex ile kontrol ?
    if (mail == null || pass == null) {
      return null; // Mail ve pass null ise boş AuthModel döndür
    } else {
      try {
              UserCredential userCredential = await _firebaseAuth!
                  .signInWithEmailAndPassword(
                email: mail, // mail'in null olmadığını garanti ediyoruz
                password: pass, // pass'in null olmadığını garanti ediyoruz
        );
        String? uid = userCredential.user?.uid;

        return uid; // Başarılı girişte uid ile AuthModel döndür
      } catch (e) {
        print('Error during login: $e');
        return null; // Hata durumunda boş uid ile AuthModel döndür
      }
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



