import 'package:flutter/material.dart';
import 'dart:io';

import 'package:gardengru/data/records/userRecord.dart';
import 'package:gardengru/data/userRecordProvider.dart';
import 'package:provider/provider.dart';

import '../data/helpers/StorageHelper.dart';// Adjust this import according to your project structure

void main() {
  runApp(InfoScreen());
}

class InfoScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  final String? path;
  final int? index;
  final userRecord? u;
  final StorageHelper storageHelper = StorageHelper();

  InfoScreen({super.key, this.data, this.path, this.index,this.u});

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
                  bool success = await storageHelper.
                  DeleteSavedItemFromStorageAndStore(
                    u!,
                    index!,
                    context
                  );

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
