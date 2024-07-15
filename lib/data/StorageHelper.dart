import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gardengru/data/FireStoreHelper.dart';
import 'package:gardengru/data/dataModels/SavedModel.dart';
import 'package:gardengru/data/dataModels/UserDataModel.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';



class StorageHelper{
  final storageRef = FirebaseStorage.instance.ref();
  StorageHelper();
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();

  Future<bool> DeleteSavedItemFromStorageAndStore(UserDataModel user,
      int savedModelIndex) async{
    try {
      if(user.userModel?.savedModels == null || user.userModel!.savedModels!.isEmpty){
        print("cannot handle the empty path request");
        return false;
      }


      SavedModel savedModel = user.userModel!.savedModels![savedModelIndex];
      final imageRef = FirebaseStorage.instance.ref().child('images/${savedModel.imagePath}');
      final textRef = FirebaseStorage.instance.ref().child('texts/${savedModel.textPath}');

      await imageRef.delete();
      await textRef.delete();

      if (await _fireStoreHelper.deleteFileReferenceFromDatabase(user, savedModel.createdAt!)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error deleting files from storage: $e");
      return false;
    }

  }


  Future<bool> UploadSavedFilesToDatabase(UserDataModel user, File image, String text, String title) async {
    try {
      final imageRef = storageRef.child('images/${DateTime.now().toString()}');
      final textRef = storageRef.child('texts/${DateTime.now().toString()}.json');

      // Upload image file
      await imageRef.putFile(image);

      // Create JSON data
      Map<String, String> data = {
        'title': title,
        'text': text,
      };

      // Convert JSON data to String
      String jsonString = jsonEncode(data);

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final path = directory.path;

      // Create a temporary JSON file and write the JSON data
      final file = File('$path/temp_data.json');
      await file.writeAsString(jsonString);

      print('JSON data written to: ${file.path}');

      // Create metadata with content type for JSON file
      SettableMetadata metadata = SettableMetadata(contentType: 'application/json');

      // Upload JSON file with metadata
      await textRef.putFile(file, metadata);

      // Add file reference to Firestore database
      if (await _fireStoreHelper.AddFileReferanceToDatabase(
          user,
          await imageRef.getDownloadURL(),
          await textRef.getDownloadURL())) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error uploading files to storage: $e");
      return false;
    }
  }

}