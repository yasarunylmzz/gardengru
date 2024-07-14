
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class SavedModel{
  String? imagePath;
  String? textPath;
  Timestamp? createdAt;
  String? text;
  File? image;
  SavedModel();
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