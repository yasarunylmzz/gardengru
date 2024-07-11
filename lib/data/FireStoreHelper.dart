import 'package:cloud_firestore/cloud_firestore.dart';
import 'dataModels/UserDataModel.dart';

class FireStoreHelper {
  FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<bool> initNewUser(UserDataModel userDataModel) async {
    try {
      // Kullanıcının UID'si ile bir belge oluştur
      DocumentReference userDocRef =
          _database.collection('data').doc(userDataModel.authModel?.uid);

      // UserModel ve AuthModel verilerini belgeye ekle
      await userDocRef.set({
        'name': userDataModel.userModel?.Name,
        'surname': userDataModel.userModel?.Surname,
        // Bu örnekte şifreyi doğrudan kaydediyoruz, ancak şifrelerin hashed olarak saklanması gereklidir.
      });

      // SavedModel için bir koleksiyon oluştur ve içindeki fieldları null olarak ayarla
      CollectionReference savedCollectionRef = userDocRef.collection('saved');
      await savedCollectionRef.add({
        // SavedModel içindeki fieldlar burada null olarak ayarlanabilir
        'imagePath': null,
        'textPath': null,
        'savedAt': DateTime.timestamp()
        // Diğer fieldlar eklenebilir
      });

      return true;
    } catch (e) {
      print("Error initializing new user: $e");
      return false;
    }
  }

  Stream<List<T>> getDocuments<T>(
    String collectionPath,
    T Function(Map<String, dynamic> data, String documentId) fromFirestore,
  ) {
    return _database.collection(collectionPath).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => fromFirestore(doc.data(), doc.id)).toList());
  }
}
