import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/helpers/FireStoreHelper.dart';
import 'package:gardengru/data/records/savedItemsRecord.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:http/http.dart' as http;

import 'dataModels/UserModelDto.dart';

class userRecordProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FireStoreHelper _storeHelper = FireStoreHelper();
  List<Map<String, String>?> _homeScreenData = [];
  bool _isLoading = true;
  userRecord _user = userRecord();
  bool _isInitialized = false;

  userRecordProvider();

  userRecord get user => _user;
  bool get isLoading => _isLoading;
  List<Map<String, String>?> get homeScreenData => _homeScreenData;


  // Initialize the logged user and home screen data
  Future<bool> initLogged() async {

    //notifyListeners();
    if(_isInitialized){
      return true;
    }
    _isLoading = true;
    userRecord? u = await _storeHelper.getUser();
    if (u != null) {
      _user = u;
      _homeScreenData = await initHomeScreenTextData();
      _isLoading = false;
      notifyListeners();
      _isInitialized = true;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Fetch and parse home screen text data
  Future<List<Map<String, String>>> initHomeScreenTextData() async {
    List<Map<String, String>> data = [];

    if (_user.getsaved == null) {
      return data;
    }

    var urls = _user.getsaved!
        .map((e) => e.textPath)
        .where((url) => url != null)
        .toList();

    for (var url in urls) {
      var d = await getSingleDataFromUrl(url);
      if (d != null) {
        data.add(d);
      }
    }
    return data;
  }

  Future<Map<String, String>?> getSingleDataFromUrl(url) async{

    Map<String, String> mapData = {};
    try {
      final response = await http.get(Uri.parse(url!));
      if (response.statusCode == 200) {
        try {
          Map<String, dynamic> jsonData = jsonDecode(response.body);
          Map<String, String> mapData = jsonData.map((key, value) {
            String stringValue = value.toString();
            return MapEntry(key, stringValue);
          });
          return mapData;
        } catch (e) {
          print("Error decoding JSON: $e");
        }
      } else {
        print("Error downloading file: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading file: $e");
    }
    return mapData;

  }



  void removeSavedItemSilently(int index) {
    _user.savedItems!.removeAt(index);
  }


  // Remove a saved item from the user record
  void removeSavedItem(int index) {
    _user.savedItems!.removeAt(index);
    notifyListeners();
  }

  // Add a saved item to the user record
  void addSavedItemModelAndHomeScreeen(SavedModel savedModel) async {
    _isLoading = true;
    notifyListeners();

    var d = await getSingleDataFromUrl(savedModel.textPath);
    if(d!= null){
      _homeScreenData.add(d);
    }
    notifyListeners();
    _user.savedItems!.add(savedModel);
    notifyListeners();
    _isLoading = false;
    notifyListeners();

  }



  // Setters that notify listeners when the state changes
  set homeScreenData(List<Map<String, String>?> data) {
    _homeScreenData = data;
    notifyListeners();
  }

  set isLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  set user(userRecord user) {
    _user = user;
    print("User set in userRecordProvider and name is: ${_user.Name}");
    notifyListeners();
  }

  // Force notify listeners (useful for manual refresh)
  void forceNotify() {
    notifyListeners();
  }

  // Initialize user record with data from Firestore
  void initUserRecord(userRecord u) async {
    String? mail = u.mail;
    String? pass = u.pass;
    String? uid = u.uid;

    if (uid == null || mail == null || pass == null) {
      return;
    }
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
      await _firestore.collection("data").doc(uid).get();
      if (!docSnapshot.exists) {
        print("User data not found");
        return;
      }
      // UserModel veri çekme
      UserModel userModel = UserModel.fromFirestore(docSnapshot.data()!);
      CollectionReference savedCollection =
      _firestore.collection('data').doc(uid).collection('saved');
      QuerySnapshot savedSnapshot = await savedCollection.get();
      // saved koleksiyonunu çekme
      List<SavedModel> savedModels = [];
      for (var doc in savedSnapshot.docs) {
        savedModels.add(SavedModel.fromFireStore(doc));
      }

      userRecord user = userRecord(
        mail: mail,
        pass: pass,
        uid: uid,
        Name: userModel.Name,
        Surname: userModel.Surname,
        savedItems: savedModels,
      );
      _user = user;
      notifyListeners();
      return;
    } catch (e) {
      print("Error initializing user record: $e");
      return;
    }
  }
  void setIsInitialized(bool isInitialized){
    _isInitialized = isInitialized;
    notifyListeners();
  }

}
