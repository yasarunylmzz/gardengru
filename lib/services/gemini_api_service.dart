import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

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

 Future<String> generateContentWithImages(String prompt, List<File> images) async {
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
}