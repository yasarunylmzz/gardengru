// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

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


  SavedModel({this.imageFileName, this.textFileName, this.imagePath, this.textPath, this.savedAt});


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