import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gardengru/data/dataModels/HomeScreenDataModel.dart';
import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/helpers/FireStoreHelper.dart';
import 'package:gardengru/data/records/savedItemsRecord.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:gardengru/services/gemini_api_service.dart';

import 'package:http/http.dart' as http;

import 'dataModels/UserModelDto.dart';

class userRecordProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FireStoreHelper _storeHelper = FireStoreHelper();
  List<Map<String, String>?> _listSavedItemScreenData
  = [];
  bool _isLoading = true;
  userRecord _user = userRecord();
  bool _isInitialized = false;
  userRecordProvider();
  userRecord get user => _user;
  bool get isLoading => _isLoading;
  List<Map<String, String>?> get listSavedItemScreenData => _listSavedItemScreenData;
  final GeminiApiService _ai = GeminiApiService();


 HomeScreenDataModel? _homeScreenDataModel;
 bool _isHomeScreenInitialized = false;
 bool _isTopHomeScreenLoading = false;
 bool _isBottomHomeScreenLoading = false;
 get isHomeScreenInitialized => _isHomeScreenInitialized;
 get isTopHomeScreenLoading => _isTopHomeScreenLoading;
 get isBottomHomeScreenLoading => _isBottomHomeScreenLoading;


  Future<void> initNewHomeScreen() async {
    if (_isHomeScreenInitialized) {
      return;
    }

    _isTopHomeScreenLoading = true;
    _isBottomHomeScreenLoading = true;
    notifyListeners();

    print('Fetching home screen data...');
    _homeScreenDataModel = await _ai.getHomeScreenData();
    print('Home screen data fetched: $_homeScreenDataModel');

    _isTopHomeScreenLoading = false;
    notifyListeners();

    print('Generating home screen article...');
    var article = await _ai.generateHomeScreenArticle();
    if (article != null) {
      _homeScreenDataModel!.setArticle = article;
    }
    print('Article generated: $article');

    _isBottomHomeScreenLoading = false;
    _isHomeScreenInitialized = true;
    notifyListeners();

    print('Home screen initialization complete.');
    print('Final home screen data: $_homeScreenDataModel');
    print('widgets: ${_homeScreenDataModel!.getWidgetDataModel!.getWidgets}');
    print('risks: ${_homeScreenDataModel!.getWidgetDataModel!.getRisks}');

  }


  // Initialize the logged user and home screen data
  Future<bool> initLogged() async {
    initNewHomeScreen();
    //notifyListeners();
    if (_isInitialized) {
      return true;
    }
    _isLoading = true;
    userRecord? u = await _storeHelper.getUser();
    if (u != null) {
      _user = u;
      _listSavedItemScreenData
      = await initHomeScreenTextData();
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
  Future<Map<String, String>?> getSingleDataFromUrl(url) async {
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
  void removeSavedItem(int index) {
    _user.savedItems!.removeAt(index);
    notifyListeners();
  }
  void addSavedItemModelAndHomeScreeen(SavedModel savedModel) async {
    _isLoading = true;
    notifyListeners();

    var d = await getSingleDataFromUrl(savedModel.textPath);
    if (d != null) {
      _listSavedItemScreenData
          .add(d);
    }
    notifyListeners();
    _user.savedItems!.add(savedModel);
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }
  set listSavedItemScreenData(List<Map<String, String>?> data) {
    _listSavedItemScreenData
    = data;
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

  void forceNotify() {
    notifyListeners();
  }

  void setIsInitialized(bool isInitialized) {
    _isInitialized = isInitialized;
    notifyListeners();
  }
}
