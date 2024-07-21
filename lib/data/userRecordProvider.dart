

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/records/savedItemsRecord.dart';
import 'package:gardengru/data/records/userRecord.dart';

import 'dataModels/UserModelDto.dart';

class  userRecordProvider extends ChangeNotifier{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLogged = false;
  userRecord _user;
  userRecordProvider(this._user);
  get isLogged => _isLogged;
  get user => _user;

  
  void initLogged(String uid){
    _user = UserModel.fromFirestore(data)
    
  }

  void addSavedItem(SavedModel savedModel){
    _user.savedItems!.add(savedModel);
    notifyListeners();
  }

  void setLogged(bool isLogged){
    _isLogged = isLogged;
    notifyListeners();
  }

  void setUserRecord(userRecord user){
    _user = user;
    notifyListeners();
  }

  void forceNotify(){
    notifyListeners();
  }
  void initUserRecord(userRecord u) async{
    String? mail = u.mail;
    String? pass = u.pass;
    String? uid = u.uid;

    if(uid == null || mail == null || pass == null){
      return;
    }
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _firestore.collection("data").doc(uid).get();
      if (!docSnapshot.exists)
      {
        print("User data not found");
        return;
      }
      // UserModel veri çekme
      UserModel userModel = UserModel.fromFirestore(docSnapshot.data()!);
      CollectionReference savedCollection = _firestore.collection('data').doc(uid).collection('saved');
      QuerySnapshot savedSnapshot = await savedCollection.get();
      // saved koleksiyonunu çekme
      List<SavedModel> savedModels = [];
      for(var doc in savedSnapshot.docs)
      {
        savedModels.add(SavedModel.fromFireStore(doc));
      }

      userRecord user = userRecord(
          mail: mail,
          pass: pass,
          uid: uid,
          Name: userModel.Name,
          Surname: userModel.Surname,
          savedItems: savedModels

      );
      _user = user;
      notifyListeners();
      return;

    } catch (e) {

      return;
    }

  }

}