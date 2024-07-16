import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dataModels/UserModel.dart';
import 'dataModels/UserDataModel.dart';
import 'dataModels/SavedModel.dart';

class FireStoreHelper {
  FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<bool> deleteFileReferenceFromDatabase(UserDataModel user, Timestamp createdAt) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('data').doc(user.authModel?.uid);
      CollectionReference savedCollectionRef = userDocRef.collection('saved');

      // Query to find the document with the specific createdAt timestamp
      QuerySnapshot savedSnapshot = await savedCollectionRef.where('savedAt', isEqualTo: createdAt).get();

      if (savedSnapshot.docs.isNotEmpty) {
        // Deleting the document
        await savedSnapshot.docs.first.reference.delete();
        return true;
      } else {
        print("No document found with the specified timestamp.");
        return false;
      }
    } catch (e) {
      print("Error deleting file reference from database: $e");
      return false;
    }
  }

  Future<UserModel?> GetUserDataFromDatabaseWithId(String id) async {
    try {
      final ref = _database.collection("data").doc(id);

      // UserModel veri çekme
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await ref.get();
      if (!docSnapshot.exists) {
        print("User data not found");
        return null;
      }

      UserModel userModel = UserModel.fromFirestore(docSnapshot.data()!);

      // saved koleksiyonunu çekme
      CollectionReference savedCollection = ref.collection('saved');
      QuerySnapshot savedSnapshot = await savedCollection.get();
      userModel.savedModels = savedSnapshot.docs
          .map((savedDoc) =>
          SavedModel.fromFirestore(savedDoc.data() as Map<String, dynamic>))
          .toList();

      return userModel;
    } catch (e) {
      print("Error getting user data from database: $e");
      return null;
    }
  }

  Future<bool> initNewUser(UserDataModel userDataModel) async {
    try {
      // Kullanıcının UID'si ile bir belge oluştur
      DocumentReference userDocRef =
      _database.collection('data').doc(userDataModel.authModel?.uid);

      // UserModel verilerini belgeye ekle
      await userDocRef.set({
        'Name': userDataModel.userModel?.Name,
        'Surname': userDataModel.userModel?.Surname,
      });

      // SavedModel için bir koleksiyon oluştur ve içindeki fieldları null olarak ayarla
      CollectionReference savedCollectionRef = userDocRef.collection('saved');
      await savedCollectionRef.add({
        'imagePath': null,
        'textPath': null,
        'savedAt': Timestamp.now(),
      });

      return true;
    } catch (e) {
      print("Error initializing new user: $e");
      return false;
    }
  }
  Future<bool> AddFileReferanceToDatabase(UserDataModel user, String imagePath,String textPath) async {


    try {
      DocumentReference userDocRef = _database.collection('data').doc(
          user.authModel?.uid);
      CollectionReference savedCollectionRef = userDocRef.collection('saved');

      await savedCollectionRef.add({
        'imagePath': imagePath,
        'textPath': textPath,
        'savedAt': Timestamp.now(),
      });
      return true;

    }
    catch(e)
    {
      print("Error adding file referance to database: $e");
      return false;
    }



  }
  Future<List<DocumentReference>> GetSavedCollectionDocumentsFromDatabaseWithUser(UserDataModel user) async {
    try {
      DocumentReference userDocRef = _database.collection('data').doc(
          user.authModel?.uid);
      CollectionReference savedCollectionRef = userDocRef.collection('saved');
      QuerySnapshot savedSnapshot = await savedCollectionRef.get();
      return savedSnapshot.docs.map((doc) => doc.reference).toList();
    }
    catch(e)
    {
      print("Error getting documents from database: $e");
      return [];
    }
  }




}
