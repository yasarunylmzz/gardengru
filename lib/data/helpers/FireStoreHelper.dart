import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gardengru/data/records/userRecord.dart';

import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart' show rootBundle;

class FireStoreHelper {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

Future<userRecord?> getUser() async {
    userRecord? u = userRecord();
    List<SavedModel> S = [];

    try {
      User? au = _auth.currentUser!;
      u.uid = au.uid;
      u.mail = au.email;
      u.pass = '';
      var d = await _database.collection('data').doc(u.uid).get();
      if (d.exists) {
        u.Name = d.data()!['Name'];
        u.Surname = d.data()!['Surname'];
      }
      var c = await _database
          .collection('data')
          .doc(u.uid)
          .collection('saved')
          .get();
      if (c.docs.isNotEmpty) {
        for (var element in c.docs) {
          SavedModel s = SavedModel(
              savedAt: element.data()['savedAt'],
              imagePath: element.data()['imagePath'],
              textPath: element.data()['textPath'],
              imageFileName: element.data()['imageFileName'],
              textFileName: element.data()['textFileName']);
          S.add(s);
        }
        u.setsaved(S);
      }
    } catch (e) {
      rethrow;
    }
    return u;
  }

  Future<bool> deleteFileReferenceFromDatabase(
      userRecord user, Timestamp createdAt) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('data').doc(user.uid);
      CollectionReference savedCollectionRef = userDocRef.collection('saved');

      // Query to find the document with the specific createdAt timestamp
      QuerySnapshot savedSnapshot =
          await savedCollectionRef.where('savedAt', isEqualTo: createdAt).get();

      if (savedSnapshot.docs.isNotEmpty) {
        // Deleting the document
        await savedSnapshot.docs.first.reference.delete();
        return true;
      } else {
  
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<SavedModel?> AddFileReferanceToDatabase(
      userRecord user,
      String imagePath,
      String textPath,
      String textFileName,
      String imageFileName) async {
    try {
      DocumentReference userDocRef = _database.collection('data').doc(user.uid);
      CollectionReference savedCollectionRef = userDocRef.collection('saved');
      var d = Timestamp.now();

      SavedModel s = SavedModel(
          imageFileName: imageFileName,
          textFileName: textFileName,
          savedAt: d,
          imagePath: imagePath,
          textPath: textPath);

      await savedCollectionRef.add({
        'imagePath': imagePath,
        'textPath': textPath,
        'savedAt': d,
        'textFileName': textFileName,
        'imageFileName': imageFileName
      });

      return s;
    } catch (e) {
     
      return null;
    }
  }

  Future<bool> initNewUser(userRecord u) async {
    try {
      
      DocumentReference userDocRef = _database.collection('data').doc(u.uid);
      await userDocRef.set({'Name': u.Name, 'Surname': u.Surname});


      return true;
    } catch (e) {
      
      return false;
    }
  }
}
