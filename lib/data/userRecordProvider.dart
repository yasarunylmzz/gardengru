import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gardengru/data/dataModels/HomeScreenDataModel.dart';
import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/helpers/FireStoreHelper.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:gardengru/services/gemini_api_service.dart';

import 'package:http/http.dart' as http;

class userRecordProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FireStoreHelper _storeHelper = FireStoreHelper();
  List<Map<String, String>?> _listSavedItemScreenData = [];
  bool _isLoading = true;
  userRecord _user = userRecord();
  bool _isInitialized = false;
  userRecordProvider();
  userRecord get user => _user;
  bool get isLoading => _isLoading;
  List<Map<String, String>?> get listSavedItemScreenData =>
      _listSavedItemScreenData;
  final GeminiApiService _ai = GeminiApiService();
  get homeScreenDataModel => _homeScreenDataModel;

  HomeScreenDataModel? _homeScreenDataModel;
  bool _isHomeScreenInitialized = false;
  bool _isTopHomeScreenLoading = false;
  bool _isBottomHomeScreenLoading = false;
  get isHomeScreenInitialized => _isHomeScreenInitialized;
  get isTopHomeScreenLoading => _isTopHomeScreenLoading;
  get isBottomHomeScreenLoading => _isBottomHomeScreenLoading;
 
  Future<void> initHomeScreenWidget() async {
    if (_isHomeScreenInitialized) {
      return;
    }
   

    _homeScreenDataModel = await _ai.getHomeScreenData();
    _isTopHomeScreenLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isTopHomeScreenLoading = false;
      notifyListeners();
    });
      _homeScreenDataModel!.setArticle = "Your daily article will be shown here";
      _isBottomHomeScreenLoading = false;
      _isHomeScreenInitialized = true;
      notifyListeners();

  }
  Future<void>setArticle() async{
    var article = await _ai.generateHomeScreenArticle();
    _isBottomHomeScreenLoading = true;
    notifyListeners();
    if (article != null) {
      _homeScreenDataModel!.setArticle = article;
      _isBottomHomeScreenLoading = false;
      notifyListeners();
      return;
    }
    print("i have a feeling this shit is null");
    print(article);
    _homeScreenDataModel!.setArticle = "Opps! Something went wrong";
    _isBottomHomeScreenLoading = false;
    notifyListeners();

  }
  
  Future<void> initUserData() async {
    
    if (_isInitialized) {
      return;
    }
    _isLoading = true;
    userRecord? u = await _storeHelper.getUser();
    if (u != null) {
      _user = u;
      _listSavedItemScreenData = await savedItemsTexts();
      _isLoading = false;
      notifyListeners();
      _isInitialized = true;
      notifyListeners();
      return;
    }
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<List<Map<String, String>>> savedItemsTexts() async {
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

  void addSavedItemListScreen(SavedModel savedModel) async {
    _isLoading = true;
    notifyListeners();

    var d = await getSingleDataFromUrl(savedModel.textPath);
    if (d != null) {
      _listSavedItemScreenData.add(d);
    }
    notifyListeners();
    _user.savedItems!.add(savedModel);
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }

  set listSavedItemScreenData(List<Map<String, String>?> data) {
    _listSavedItemScreenData = data;
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
