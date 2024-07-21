import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:provider/provider.dart';

import 'package:gardengru/data/helpers/StorageHelper.dart';

import '../data/userRecordProvider.dart';

Future<bool> postSavedItemToDatabase(String? text, String? title, File? image,context) async {
  try {
    StorageHelper storageHelper = StorageHelper();
    userRecord u = context.read<userRecordProvider>().user;
    userRecord? newU = await storageHelper.UploadSavedFilesToDatabase(
        u,
        image!,
        text!,
        title!
    );
    SavedModel s = SavedModel(
      imageFileName: newU!.savedItems?.last.imageFileName,
      textFileName: newU.savedItems?.last.textFileName,
      savedAt: newU.savedItems?.last.savedAt,
      imagePath: newU.savedItems?.last.imagePath,
      textPath: newU.savedItems?.last.textPath,

    );
    context.read().addSavedItem(s);
    return true;
  }
  catch (e) {
    print("Error posting saved item to database: $e");
    return false;
  }

}

class ResultTestScreen extends StatefulWidget {
  final String title;
  final String text;
  final File image;

  ResultTestScreen({
    required this.title,
    required this.text,
    required this.image,
  });

  @override
  _ResultTestScreenState createState() => _ResultTestScreenState();
}

class _ResultTestScreenState extends State<ResultTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(widget.image),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
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
                    widget.text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        postSavedItemToDatabase(
                            widget.text,
                            widget.title,
                            widget.image,
                            //context.read<userRecordProvider>().user,
                            context,
                        ).then((result) {
                          //context.read().addSavedItem(result!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result ? 'Data posted successfully' : 'Failed to post data'),
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
