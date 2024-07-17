import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gardengru/data/FireStoreHelper.dart';
import 'package:gardengru/data/dataModels/SavedModel.dart';
import 'package:gardengru/data/dataModels/UserDataModel.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';



class StorageHelper{
  final storageRef = FirebaseStorage.instance.ref();
  StorageHelper();
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();


  Future<bool> DeleteSavedItemFromStorageAndStore(UserDataModel user, int savedModelIndex) async {
    try {
      if (user.userModel?.savedModels == null || user.userModel!.savedModels!.isEmpty) {
        print("Cannot handle the empty path request");
        return false;
      }

      SavedModel savedModel = user.userModel!.savedModels![savedModelIndex];
      String imagePath = savedModel.imageFileName!;
      String textPath = savedModel.textFileName!;

      FirebaseStorage _store = FirebaseStorage.instance;

      // Print paths for debugging
      print("Deleting image at path: $imagePath");
      print("Deleting text at path: $textPath");

      try {
        await _store.ref(imagePath).delete();
        print("Image file deleted successfully");
      } catch (e) {
        print("Error deleting image file: $e");
      }

      try {
        await _store.ref(textPath).delete();
        print("Text file deleted successfully");
      } catch (e) {
        print("Error deleting text file: $e");
      }

      if (await _fireStoreHelper.deleteFileReferenceFromDatabase(user, savedModel.createdAt!)) {
        print("File references deleted from database successfully");
        return true;
      } else {
        print("Failed to delete file references from database");
        return false;
      }
    } catch (e) {
      print("Error deleting files from storage: $e");
      return false;
    }
  }


  Future<bool> UploadSavedFilesToDatabase(UserDataModel user, File image, String text, String title) async {
    try {
      final prename = DateTime.now().toString();

       final desiredFileName = prename.replaceAll(RegExp(r'\s+'), '');

      final imageRef = storageRef.child('images/$desiredFileName');
      final textRef = storageRef.child('texts/$desiredFileName.json');

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
          await textRef.getDownloadURL(),
          'texts/$desiredFileName.json',
          'images/$desiredFileName.jpeg'
      )) {
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