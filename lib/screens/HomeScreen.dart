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

  Future<List<Map<String, dynamic>>> fetchData(String url) async {
    if (url.isEmpty) {
      throw Exception('URL is empty');
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
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
          print("home screen");
          userRecord u = usr.user;
          print("home screen watched and first textfilepath is ${u.savedItems?[0].textPath}");
          //print(u.savedItems?[0].textFileName);


          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: u.savedItems?.length,
            itemBuilder: (context, index) {
              final textPath = u.savedItems?[index].textPath ?? '';
              // Debug: Print the URL
              print('Fetching data from URL: $textPath');

              return FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData(textPath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final List<Map<String, dynamic>> dataList = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        final data = dataList[index];
                        final title = data['title'] as String?;
                        final text = data['text'] as String?;
                        final imagePath = u.savedItems?[index].imagePath;

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
