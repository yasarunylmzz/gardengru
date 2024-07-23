import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:provider/provider.dart';
import 'package:gardengru/data/helpers/StorageHelper.dart';
import '../data/userRecordProvider.dart';

Future<SavedModel?> postSavedItemToDatabase(
    String? text, String? title, File? image, userRecord u) async {
  try {
    StorageHelper storageHelper = StorageHelper();
    SavedModel? s = await storageHelper.UploadSavedFilesToDatabase(
        u,
        image!,
        text!,
        title!
    );
    return s;
  } catch (e) {
    print("Error posting saved item to database: $e");
    return null;
  }
}

class ResponseScreen extends StatefulWidget {
  final String title;
  final String text;
  final File image;

  ResponseScreen({
    required this.title,
    required this.text,
    required this.image,
  });

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  bool _isLoading = false;

  void _handleSaveData() {
    setState(() {
      _isLoading = true;
    });

    postSavedItemToDatabase(
        widget.text,
        widget.title,
        widget.image,
        context.read<userRecordProvider>().user
    ).then((result) {
      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        Provider.of<userRecordProvider>(context, listen: false)
            .addSavedItemModelAndHomeScreeen(result);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((result != null) ? 'Data posted successfully' : 'Failed to post data'),
        ),
      );
    });
  }

  TextSpan _getStyledTextSpan(String text) {
    final RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
    final RegExp italicPattern = RegExp(r'\*(.*?)\*');

    List<TextSpan> spans = [];
    int currentIndex = 0;

    text.splitMapJoin(
      boldPattern,
      onMatch: (Match match) {
        if (currentIndex < match.start) {
          spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
        }
        spans.add(TextSpan(
          text: match.group(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
        currentIndex = match.end;
        return '';
      },
      onNonMatch: (String nonMatch) {
        spans.add(TextSpan(text: nonMatch));
        return '';
      },
    );

    List<TextSpan> finalSpans = [];
    spans.forEach((span) {
      String? spanText = span.text;
      if (spanText != null) {
        int currentSpanIndex = 0;
        spanText.splitMapJoin(
          italicPattern,
          onMatch: (Match match) {
            if (currentSpanIndex < match.start) {
              finalSpans.add(TextSpan(text: spanText.substring(currentSpanIndex, match.start), style: span.style));
            }
            finalSpans.add(TextSpan(
              text: match.group(1),
              style: span.style?.merge(TextStyle(fontStyle: FontStyle.italic)) ?? TextStyle(fontStyle: FontStyle.italic),
            ));
            currentSpanIndex = match.end;
            return '';
          },
          onNonMatch: (String nonMatch) {
            finalSpans.add(TextSpan(text: nonMatch, style: span.style));
            return '';
          },
        );
      } else {
        finalSpans.add(span);
      }
    });

    return TextSpan(children: finalSpans, style: TextStyle(fontSize: 16, color: Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                          fontSize: 20,
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
                      RichText(
                        text: _getStyledTextSpan(widget.text),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSaveData,
                          child: Text('Save Data'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: SpinKitThreeBounce(
                  color: Colors.green,
                  size: 50.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
