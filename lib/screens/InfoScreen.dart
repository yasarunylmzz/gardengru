// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:gardengru/data/records/userRecord.dart';
import '../data/helpers/StorageHelper.dart'; // Adjust this import according to your project structure

void main() {
  runApp(InfoScreen());
}

class InfoScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  final String? path;
  final int? index;
  final userRecord? u;
  final StorageHelper storageHelper = StorageHelper();

  InfoScreen({super.key, this.data, this.path, this.index, this.u});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(data?['title'].replaceAll(RegExp(r'^##'), '') ?? 'Info'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (path != null)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: path!,
                      child: Image.network(
                        path ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                data?['title'].replaceAll(RegExp(r'^##'), '') ?? 'No Title',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: _buildRichText(data?['text'] ?? 'No Data'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  bool success =
                      await storageHelper.DeleteSavedItemFromStorageAndStore(
                          u!, index!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Item deleted successfully'
                          : 'Failed to delete item'),
                    ),
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRichText(String text) {
    // Remove all instances of '*'
    text = text.replaceAll('*', '');
    final pattern = text.contains('-') ? RegExp(r'-(.*?):') : RegExp(r'(.*?):');
    final matches = pattern.allMatches(text);
    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      if (currentIndex < match.start) {
        // Add normal text before the match
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }
      // Add bold text within the match
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      currentIndex = match.end;
    }
    if (currentIndex < text.length) {
      // Add remaining text after the last match
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        children: spans,
      ),
    );
  }
}
