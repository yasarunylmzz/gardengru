import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gardengru/data/userRecordProvider.dart';
import 'package:gardengru/screens/InfoScreen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../data/records/userRecord.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, String>?> getJsonAsMapFromStorage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data.map((key, value) {
          String stringValue = value.toString();
          return MapEntry(key, stringValue);
        });
      } else {
        print("Error downloading file: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error downloading file: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Home'),
        ),
      ),
      body: Consumer<userRecordProvider>(
        builder: (context, usr, child) {
          userRecord u = usr.user;
          return FutureBuilder<List<Map<String, String>?>>(
            future: Future.wait(u.getsaved
                    ?.map((record) =>
                        getJsonAsMapFromStorage(record.gettextPath.toString()))
                    .toList() ??
                []),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data found'));
              } else {
                final List<Map<String, String>?> dataList = snapshot.data!;

                return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final dataMap = dataList[index];
                    final title =
                        dataMap?['title']?.replaceAll(RegExp(r'^##'), '');
                    final text = dataMap?['text'];
                    final imagePath = u.getsaved?[index].getimagePath;

                    return Dismissible(
                      key: Key(index.toString()),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {},
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoScreen(
                                u: u,
                                data: dataMap,
                                path: imagePath,
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Hero(
                                      tag: imagePath ?? 'hero',
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Image(
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                            imagePath ??
                                                'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title != null
                                              ? (title.length > 20
                                                  ? '${title.substring(0, 25)}...'
                                                  : title)
                                              : 'Loading...',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          text != null
                                              ? '${text.substring(0, text.length > 30 ? 30 : text.length)}...'
                                              : 'Loading...',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xff011928),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
