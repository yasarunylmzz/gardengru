import 'dart:convert';
import 'package:flutter/material.dart';
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer<userRecordProvider>(
        builder: (context, usr, child) {
          userRecord u = usr.user;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: u.getsaved?.length ?? 0,
            itemBuilder: (context, index) {
              final textPath = u.getsaved?[index].gettextPath ?? '';

              print('Fetching data from URL: $textPath');

              return FutureBuilder<Map<String, String>?>(
                future: getJsonAsMapFromStorage(textPath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data found'));
                  } else {
                    final Map<String, String>? dataMap = snapshot.data;

                    if (dataMap == null || dataMap.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    final List<Map<String, dynamic>> dataList = [];
                    dataMap.forEach((key, value) {
                      dataList.add({'title': key, 'text': value});
                    });

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        final data = dataList[index];
                        final title = data['title'] as String?;
                        final text = data['text'] as String?;
                        final imagePath = u.getsaved?[index].getimagePath;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoScreen(
                                  u: u,
                                  data: data,
                                  path: imagePath,
                                  index: index,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            height: 75,
                            color: Colors.white,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                        child: Image(
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                            imagePath ?? 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title ?? "Loading...",
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            text != null ? '${text.substring(0, 30)}...' : 'Loading...',
                                            style: const TextStyle(fontSize: 14),
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
                        );
                      },
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
