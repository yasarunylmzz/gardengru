
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class SavedModel{
  String? imagePath;
  String? textPath;
  Timestamp? createdAt;
  String? text;
  File? image;
<<<<<<< Updated upstream
  SavedModel();
=======
  String? textFileName;
  String? imageFileName;

  SavedModel({this.imagePath, this.textPath});
>>>>>>> Stashed changes

  String? get getText => text;
  set setText(String? value) {
    text = value;
  }

  // Getter and Setter for image
  File? get getImage => image;
  set setImage(File? value) {
    image = value;
  }



  factory SavedModel.fromFirestore(Map<String, dynamic> firestore) {
    SavedModel savedModel = SavedModel()
      ..imagePath = firestore['imagePath']
      ..textPath = firestore['textPath']
      ..createdAt = firestore['savedAt'];

    return savedModel;
  }
  Map<String, dynamic> toFirestore() {
    return {
      'imagePath': imagePath,
      'textPath': textPath,
      'savedAt': createdAt,

    };
  }



}