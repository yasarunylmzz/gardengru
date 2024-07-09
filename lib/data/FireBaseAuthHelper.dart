import 'package:firebase_auth/firebase_auth.dart';
import 'dataModels/AuthModel.dart';

class FireBaseAuthHelper {
  FirebaseAuth? _firebaseAuth;

  FireBaseAuthHelper();

  Future<void> initAuthDb() async {
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<AuthModel> tryLogin(AuthModel authModel) async {
    await initAuthDb(); // initAuthDb'i await ile çağırıyoruz
    if (authModel.mail == null || authModel.pass == null) {
      return AuthModel('', '', ''); // Mail ve pass null ise boş AuthModel döndür
    } else {
      try {
        UserCredential userCredential = await _firebaseAuth!.signInWithEmailAndPassword(
          email: authModel.mail!, // mail'in null olmadığını garanti ediyoruz
          password: authModel.pass!, // pass'in null olmadığını garanti ediyoruz
        );
        String? uid = userCredential.user?.uid;
        return AuthModel(uid, authModel.mail, authModel.pass); // Başarılı girişte uid ile AuthModel döndür
      } catch (e) {
        print('Error during login: $e');
        return AuthModel('', authModel.mail, authModel.pass); // Hata durumunda boş uid ile AuthModel döndür
      }
    }
  }
}
