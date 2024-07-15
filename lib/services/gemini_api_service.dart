import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;

class GeminiApiService {
  late GenerativeModel _model;

  GeminiApiService() {
    //todo: api key enviroment değişkeni olmalıymış açık açık yazılmazmış
    // flutter run --dart vsvs hata verdiği için açıkça yazıldı
    final apiKey = 'AIzaSyC8wUrkoW9B7yQEzJ1L9LmwL_m1vdCm5fM';
    if (apiKey == null) {
      throw Exception('No \$API_KEY environment variable');
    }
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

 Future<String> generateContentWithImages(List<File> images, LocationData locationData) async {

   final String res = await rootBundle.loadString('assets/prompt.json');
   final data = await json.decode(res);


    final prompt = data['InfoPrompt'] +  locationData.latitude.toString() + locationData.longitude.toString();
    final promptPart = TextPart(prompt);
    final imageParts = await Future.wait(images.map((image) async {
      final bytes = await image.readAsBytes();
      return DataPart('image/jpeg', bytes);
    }));

    final response = await _model.generateContent([
      Content.multi([promptPart, ...imageParts])
    ]);

    return response.text??"Bir şeyler hatalı";
}
  Future<String> generateTitle(String text) async{
    final String res = await rootBundle.loadString('assets/prompt.json');
    final data = await json.decode(res);
    final prompt = data["TitlePrompt"] + text ;
    final responce = await
                  _model.generateContent([Content.text(prompt)]);
    return responce.text ?? ' ';
  }

}