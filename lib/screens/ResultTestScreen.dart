import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gardengru/data/StorageHelper.dart';

import 'package:gardengru/data/dataModels/SavedModel.dart';
import 'package:gardengru/data/dataModels/UserDataModel.dart';
import 'package:gardengru/services/gemini_api_service.dart';
import 'package:provider/provider.dart';

import '../data/UserDataProvider.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> postSavedItemToDatabase(SavedModel savedModel, context,String title) async {
  StorageHelper storageHelper = StorageHelper();
  UserDataModel  user  = Provider.of<UserDataProvider>(context, listen: false).userDataModel;
  if(await storageHelper.UploadSavedFilesToDatabase(user,
      savedModel.image!,
      savedModel.text!, title)){
    user.userModel!.savedModels!.add(savedModel);
    Provider.of<UserDataProvider>(context, listen: false).setUserModel(user.userModel!);
    return true;
  }
  return false;
}

class ResultTestScreen extends StatelessWidget {
  final SavedModel savedModel;
  final String title;
 // Kullanıcı veri sağlayıcıyı ekledik

  ResultTestScreen({
    required this.savedModel,
    required this.title,
 // Kullanıcı veri sağlayıcıyı zorunlu hale getirdik
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arenosol Soil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            savedModel.image != null
                ? Image.file(savedModel.image!)
                : Text('No image available'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    savedModel.text!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                      child: ElevatedButton(
                      onPressed: () {
                    postSavedItemToDatabase(savedModel, context, title).then((result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    content: Text(result
                    ? 'Data posted successfully'
                        : 'Failed to post data'),
                    ),
                    );
                    });
                    },
                      child: Text('Save Data'),
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
