// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

<<<<<<< Updated upstream
class SavedModel{
  String? imageFileName;
  String? textFileName;
  String? imagePath;
  String? textPath;
  Timestamp? savedAt;
  String? get getimageFileName => imageFileName;
  String? get gettextFileName => textFileName;
  String? get getimagePath => imagePath;
  String? get gettextPath => textPath;
  Timestamp? get getsavedAt => savedAt;

=======
class SavedModel {
  String? _imageFileName;
>>>>>>> Stashed changes

  String? get imageFileName => _imageFileName;

  set imageFileName(String? value) {
    _imageFileName = value;
  }

  String? _textFileName;

  String? get textFileName => _textFileName;

  set textFileName(String? value) {
    _textFileName = value;
  }

  String? _imagePath;

  String? get imagePath => _imagePath;

  set imagePath(String? value) {
    _imagePath = value;
  }

  String? _textPath;

  String? get textPath => _textPath;

  set textPath(String? value) {
    _textPath = value;
  }

  Timestamp? _savedAt;

  Timestamp? get savedAt => _savedAt;

  set savedAt(Timestamp? value) {
    _savedAt = value;
  }

  SavedModel(
      {String? imageFileName,
      String? textFileName,
      String? imagePath,
      String? textPath,
      Timestamp? savedAt})
      : _savedAt = savedAt,
        _textPath = textPath,
        _imagePath = imagePath,
        _textFileName = textFileName,
        _imageFileName = imageFileName;


  factory SavedModel.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SavedModel(
      imageFileName: data['imageFileName'],
      textFileName: data['textFileName'],
      imagePath: data['imagePath'],
      textPath: data['textPath'],
      savedAt: data['savedAt'],
    );
  }
  static Map<String, dynamic> toFirebase(SavedModel savedModel) {
    return {
      'imageFileName': savedModel.imageFileName,
      'textFileName': savedModel.textFileName,
      'imagePath': savedModel.imagePath,
      'textPath': savedModel.textPath,
      'savedAt': savedModel.savedAt,
    };
  }
}
