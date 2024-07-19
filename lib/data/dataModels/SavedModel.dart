
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class SavedModel{
  String? imagePath;
  String? textPath;
  Timestamp? createdAt;
  String? text;
  File? image;
  String? textFileName;
  String? imageFileName;

  SavedModel({this.imagePath, this.textPath});


  get getImageFileName => imageFileName;
  get getTextFileName => textFileName;
  
  set setTextFileName(String? value) {
    textFileName = value;
  }
  set setImageFileName(String? value) {
    imageFileName = value;
  }



  set setText(String? value) {
    text = value;
  }

  String? get getText => text;// Getter and Setter for image
  File? get getImage => image;
  set setImage(File? value) {
    image = value;
  }



  factory SavedModel.fromFirestore(Map<String, dynamic> firestore) {
    SavedModel savedModel = SavedModel()
      ..imagePath = firestore['imagePath']
      ..textPath = firestore['textPath']
      ..createdAt = firestore['savedAt']
       ..textFileName = firestore['textFileName']
      ..imageFileName = firestore['imageFileName'];


    return savedModel;
  }
  Map<String, dynamic> toFirestore() {
    return {
      'imagePath': imagePath,
      'textPath': textPath,
      'savedAt': createdAt,
      'textFileName': textFileName,
      'imageFileName': imageFileName




    };
  }



}