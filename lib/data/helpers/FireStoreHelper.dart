import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:provider/provider.dart';
import 'package:gardengru/data/dataModels/UserModelDto.dart';

import 'package:gardengru/data/dataModels/SavedModelDto.dart';

import '../userRecordProvider.dart';

class FireStoreHelper {
  FirebaseFirestore _database = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<userRecord?> getUser() async {
    userRecord? u = userRecord();
    List<SavedModel> S = [];
    print("get user called");

    try {
      User? au = _auth.currentUser!;
      if (au != null) {
        u.uid = au.uid;
        u.mail = au.email;
        u.pass = '';
      }
      print(u.mail);

       var d = await _database.collection('data').doc(u.uid).get();
          if (d.exists) {
            u.Name = d.data()!['Name'];
            u.Surname = d.data()!['Surname'];
          }
          print("getuser setted name surname and name is: ");
          print(u.Name);



         var c = await _database.collection('data').doc(u.uid).collection('saved').get();


        if (c.docs.isNotEmpty) {
          for (var element in c.docs) {
            SavedModel s = SavedModel(
                savedAt: element.data()['savedAt'],
                imagePath: element.data()['imagePath'],
                textPath: element.data()['textPath'],
                imageFileName: element.data()['imageFileName'],
                textFileName: element.data()['textFileName']
            );
            print("setting saved");
            print(s.textPath);
            S.add(s);
          }
          u.setsaved(S);

        }


    } catch (e) {
      print("Error getting user: $e");
    }
    print("getuser finished his job");
    return u;
  }


  Future<bool> deleteFileReferenceFromDatabase(userRecord user,
      Timestamp createdAt) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection(
          'data').doc(user.uid);
      CollectionReference savedCollectionRef = userDocRef.collection('saved');

      // Query to find the document with the specific createdAt timestamp
      QuerySnapshot savedSnapshot = await savedCollectionRef.where(
          'savedAt', isEqualTo: createdAt).get();

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


  Future<userRecord?> AddFileReferanceToDatabase
      (userRecord user, String imagePath, String textPath, String textFileName,
      String imageFileName) async
  {
    try {
      DocumentReference userDocRef = _database.collection('data').doc(
          user.uid);
      CollectionReference savedCollectionRef = userDocRef.collection('saved');
      var d = Timestamp.now();

      SavedModel s = SavedModel(
          imageFileName: imageFileName,
          textFileName: textFileName,
          savedAt: d,
          imagePath: imagePath,
          textPath: textPath
      );

      await savedCollectionRef.add({
        'imagePath': imagePath,
        'textPath': textPath,
        'savedAt': d,
        'textFileName': textFileName,
        'imageFileName': imageFileName
      });
      user.savedItems?.add(s);

      return user;
    }
    catch (e) {
      print("Error adding file referance to database: $e");
      return null;
    }
  }

  Future<bool> initNewUser(userRecord u) async {
    try {
      // Kullanıcının UID'si ile bir belge oluştur
      DocumentReference userDocRef =
      _database.collection('data').doc(u.uid);

      // UserModel verilerini belgeye ekle
      await userDocRef.set({
        'Name': u.Name,
        'Surname': u.Surname
      });

      // SavedModel için bir koleksiyon oluştur ve içindeki fieldları null olarak ayarla
      CollectionReference savedCollectionRef = userDocRef.collection('saved');
      await savedCollectionRef.add({
        //TODO this should be a unique welcome saved item
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


}
