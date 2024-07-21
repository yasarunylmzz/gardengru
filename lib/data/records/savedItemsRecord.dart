import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class savedItemsRecord{
  String? imageFileName;
  String? textFileName;
  String? imagePath;
  String? textPath;
  Timestamp? savedAt;
  File? imageFile;
  File? textFile;

  savedItemsRecord({this.imageFileName, this.textFileName, this.imagePath, this.textPath, this.savedAt, this.imageFile, this.textFile});

}