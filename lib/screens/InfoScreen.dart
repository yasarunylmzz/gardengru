import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gardengru/data/StorageHelper.dart';
import 'package:gardengru/data/dataModels/UserDataModel.dart';
import 'package:provider/provider.dart';

import '../data/UserDataProvider.dart';// Adjust this import according to your project structure

void main() {
  runApp(InfoScreen());
}

class InfoScreen extends StatelessWidget {
  final Map<String, String>? data;
  final String? path;
  final int? index;
  final StorageHelper storageHelper = StorageHelper();

  InfoScreen({Key? key, this.data, this.path, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(data?['title'] ?? 'Info'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (path != null)
                Image.network(
                  path ?? "",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16),
              Text(
                data?['title'] ?? 'No Title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(data?['text'] ?? 'No Data'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  bool success = await storageHelper.DeleteSavedItemFromStorageAndStore(
                    Provider.of<UserDataProvider>(context, listen: false).userDataModel,
                      index!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Item deleted successfully' : 'Failed to delete item'),
                    ),
                  );
                },
                child: Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
