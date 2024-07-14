import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:gardengru/data/FireStoreHelper.dart';
import 'package:gardengru/data/dataModels/SavedModel.dart';
import 'package:gardengru/data/dataModels/UserDataModel.dart';

class StorageHelper{
  final storageRef = FirebaseStorage.instance.ref();
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();

  Future<bool> UploadSavedFilesToDatabase(UserDataModel user,File image, File text) async {

    try { final imageRef = storageRef.child('images/${DateTime.now().toString()}');
          final textRef = storageRef.child('texts/${DateTime.now().toString()}');
          await imageRef.putFile(image);
          await textRef.putFile(text);

          if(await _fireStoreHelper.AddFileReferanceToDatabase(user,
              imageRef.getDownloadURL().toString(), textRef.getDownloadURL().toString()))
            {
              return true;
            }
          else
            {
              return false;
            }} catch (e) {
              print("Error uploading files to storage: $e");
              return false;
            }
  }


}