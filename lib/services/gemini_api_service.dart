import 'dart:convert';
import 'dart:io';
import 'package:gardengru/data/dataModels/HomeScreenDataModel.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'location_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiService {
  late GenerativeModel _model;
  late Map<String, dynamic> _promptData;
  late Future<void> _initialization;
  final LocationService _locationServices = LocationService();

  GeminiApiService() {
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    await dotenv.load(fileName: ".env");
    var apiKey = dotenv.env['APIKEY']!;
    
    var safe = [
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.low)
    ];
    _model = GenerativeModel(
        model: 'gemini-1.5-flash', apiKey: apiKey, safetySettings: safe);
    //  _baseModel = GenerativeModel(model: 'gemini-1.5-flush', apiKey: apiKey);
    final String res = await rootBundle.loadString('assets/prompt.json');
    _promptData = json.decode(res);
  }

  Future<String> generateContentWithImages(
      List<File> images, LocationData locationData) async {
    await _initialization; // Ensure initialization is complete
    final prompt = _promptData['InfoPrompt'] +
        locationData.latitude.toString() +
        locationData.longitude.toString();
    final promptPart = TextPart(prompt);
    final imageParts = await Future.wait(images.map((image) async {
      final bytes = await image.readAsBytes();
      return DataPart('image/jpeg', bytes);
    }));

    final response = await _model.generateContent([
      Content.multi([promptPart, ...imageParts])
    ]);

    return response.text ?? "Something went wrong";
  }

  Future<String> generateTitle(String text) async {
    await _initialization; // Ensure initialization is complete
    final prompt = _promptData["TitlePrompt"] + text;
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? ' ';
  }

  Future<HomeScreenDataModel?> getHomeScreenData() async {
     await _initialization; // Ensure initialization is complete
    LocationData locationData = await _locationServices.getCurrentLocation();
    final prompt = _promptData['HomeScreenJsonPrompt'];
    final response = await _model.generateContent([
          Content.text(locationData.latitude.toString())
        ] +
        [Content.text(locationData.longitude.toString())] +
        [Content.text(prompt)]);
    if (response.text == null) {
      return null;
    }
    return HomeScreenDataModel(response.text!);
  }

  Future<String?> generateHomeScreenArticle() async {
    await _initialization; // Ensure initialization is complete
    final prompt = _promptData['HomeScreenArticlePrompt'];
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text;
  }
}
