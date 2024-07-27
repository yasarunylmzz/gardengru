import 'package:flutter/material.dart';
import 'package:gardengru/data/records/userRecord.dart';
import '../data/helpers/StorageHelper.dart'; // Adjust this import according to your project structure

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InfoScreen(),
  ));
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: FlexibleSpaceBar(
              background: path != null
                  ? Hero(
                      tag: path!,
                      child: Image.network(
                        path ?? "",
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(color: Colors.grey),
            ),
            floating: false,
            pinned: true,
            snap: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          data?['title'].replaceAll(RegExp(r'^##'), '') ??
                              'Info',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center, // Center the text
                        ),
                      ),
                      _buildRichText(data?['text'] ?? 'No Data'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(String text) {
    text = text.replaceAll('*', '');
    final pattern = text.contains('-') ? RegExp(r'-(.*?):') : RegExp(r'(.*?):');
    final matches = pattern.allMatches(text);
    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      if (currentIndex < match.start) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      currentIndex = match.end;
    }
    if (currentIndex < text.length) {
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
