import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:location/location.dart';
import 'package:gardengru/data/dataModels/HomeScreenDataModel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'location_services.dart';

class GeminiApiService {
  late GenerativeModel _model;
  late Map<String, dynamic> _promptData;
  late Future<void> _initialization;
  LocationService _locationServices = LocationService();


  GeminiApiService() {
    _initialization = _initialize();
  }
//TODO may responses regex ???
  Future<void> _initialize() async {
    final apiKey = 'AIzaSyC8wUrkoW9B7yQEzJ1L9LmwL_m1vdCm5fM'; // Replace this with your environment variable method for production.
    if (apiKey == null) {
      throw Exception('No \$API_KEY environment variable');
    }
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
    final String res = await rootBundle.loadString('assets/prompt.json');
    _promptData = json.decode(res);
  }

  Future<String> generateContentWithImages(List<File> images, LocationData locationData) async {
    await _initialization; // Ensure initialization is complete
    final prompt = _promptData['InfoPrompt'] + locationData.latitude.toString() + locationData.longitude.toString();
    final promptPart = TextPart(prompt);
    final imageParts = await Future.wait(images.map((image) async {
      final bytes = await image.readAsBytes();
      return DataPart('image/jpeg', bytes);
    }));

    final response = await _model.generateContent([
      Content.multi([promptPart, ...imageParts])
    ]);

    return response.text ?? "Bir şeyler hatalı";
  }

  Future<String> generateTitle(String text) async {
    await _initialization; // Ensure initialization is complete
    final prompt = _promptData["TitlePrompt"] + text;
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? ' ';
  }

  Future<HomeScreenDataModel?> getHomeScreenData() async {
    //GenerativeModel  _jsonmodel = GenerativeModel(model: 'tunedModels/json-sqmckkzcylvs', apiKey: 'AIzaSyC8wUrkoW9B7yQEzJ1L9LmwL_m1vdCm5fM');

    await _initialization; // Ensure initialization is complete
    LocationData locationData = await _locationServices.getCurrentLocation();
    final prompt = _promptData['HomeScreenJsonPrompt'];
    final response = await _model.generateContent(
        [Content.text(locationData.latitude.toString())]
        +
        [Content.text(locationData.longitude.toString())]
        +
        [Content.text(prompt)]

    );
    if (response.text == null) {
      return null;
    }
    print("json response: ${response.text}");
    return HomeScreenDataModel(response.text!);
  }

  Future<String?> generateHomeScreenArticle() async {
    await _initialization; // Ensure initialization is complete
    final prompt = _promptData['HomeScreenArticlePrompt'];
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text;
  }
}
