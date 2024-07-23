import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:gardengru/screens/BottomNavScreen.dart';
import 'package:provider/provider.dart';
import 'package:gardengru/data/helpers/StorageHelper.dart';
import '../data/userRecordProvider.dart';
import 'HomeScreen.dart';

Future<SavedModel?> postSavedItemToDatabase(
    String? text, String? title, File? image, userRecord u) async {
  try {
    StorageHelper storageHelper = StorageHelper();
    SavedModel? s = await storageHelper.UploadSavedFilesToDatabase(
        u, image!, text!, title!);
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

    postSavedItemToDatabase(widget.text, widget.title, widget.image,
            context.read<userRecordProvider>().user)
        .then((result) {
      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        Provider.of<userRecordProvider>(context, listen: false)
            .addSavedItemModelAndHomeScreeen(result);
      }

      final snackBar = SnackBar(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            children: [
              Icon(
                result != null ? Icons.check : Icons.error,
                size: 24.0,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      result != null
                          ? 'Data posted successfully'
                          : 'Failed to post data',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your soil query has been successfully recorded.',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        margin: const EdgeInsets.all(8),
        backgroundColor:
            (result != null ? Colors.green : Colors.red).withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        elevation: 6.0,
        duration: const Duration(seconds: 5),
        showCloseIcon: true,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Future.delayed(const Duration(seconds: 6), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomNavScreen()));
      });
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
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              finalSpans.add(TextSpan(
                  text: spanText.substring(currentSpanIndex, match.start),
                  style: span.style));
            }
            finalSpans.add(TextSpan(
              text: match.group(1),
              style: span.style
                      ?.merge(const TextStyle(fontStyle: FontStyle.italic)) ??
                  const TextStyle(fontStyle: FontStyle.italic),
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

    return TextSpan(
        children: finalSpans,
        style: const TextStyle(fontSize: 16, color: Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  title: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  background: Image.file(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
                floating: false,
                pinned: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          RichText(
                            text: _getStyledTextSpan(widget.text),
                          ),
                          const SizedBox(height: 16),
                          Center(
                              child: ElevatedButton(
                            onPressed: _handleSaveData,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.9,
                                  MediaQuery.of(context).size.height * 0.07),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Save Data',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
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
