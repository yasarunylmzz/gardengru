
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper{

  FirebaseFirestore _database = FirebaseFirestore.instance;

    Stream<List<T>> getDocuments<T>(
        String collectionPath,
        T Function(Map<String, dynamic> data, String documentId) fromFirestore,
        ) {
      return _database.collection(collectionPath).snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => fromFirestore(doc.data(), doc.id)).toList());
    }

}
