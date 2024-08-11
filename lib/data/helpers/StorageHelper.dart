import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'FireStoreHelper.dart';
import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  final storageRef = FirebaseStorage.instance.ref();
  StorageHelper();
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();

  Future<bool> DeleteSavedItemFromStorageAndStore(
      userRecord user, int savedModelIndex) async {
    try {
      if (user.savedItems == null) {
        return false;
      }

      SavedModel savedModel = user.savedItems![savedModelIndex];
      String imagePath = savedModel.imageFileName!;
      String textPath = savedModel.textFileName!;

      FirebaseStorage store = FirebaseStorage.instance;

      try {
        await store.ref(imagePath).delete();
       
      } catch (e) {
        rethrow;
      }

      try {
        await store.ref(textPath).delete();
      
      } catch (e) {
rethrow;
      }

      if (await _fireStoreHelper.deleteFileReferenceFromDatabase(
          user, savedModel.savedAt!)) {
      
        user.savedItems?.removeAt(savedModelIndex);
        return true;
      } else {
    
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<SavedModel?> UploadSavedFilesToDatabase(
      userRecord user, File image, String text, String title) async {
    try {
      final prename = DateTime.now().toString();

      final desiredFileName = prename.replaceAll(RegExp(r'\s+'), '');

      final imageRef = storageRef.child('images/$desiredFileName.jpeg');
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

      // Create metadata with content type for JSON file
      SettableMetadata metadata =
          SettableMetadata(contentType: 'application/json');

      // Upload JSON file with metadata
      await textRef.putFile(file, metadata);

      // Add file reference to Firestore database
      return await _fireStoreHelper.AddFileReferanceToDatabase(
          user,
          await imageRef.getDownloadURL(),
          await textRef.getDownloadURL(),
          'texts/$desiredFileName.json',
          'images/$desiredFileName.jpeg');
    } catch (e) {
      return null;
    }
  }
}
