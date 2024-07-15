import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gardengru/data/dataModels/UserDataModel.dart';
import 'package:gardengru/screens/InfoScreen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../data/UserDataProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>?> jsonDataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    UserDataModel user = Provider.of<UserDataProvider>(context, listen: false).userDataModel;
    if (user.userModel?.savedModels != null) {
      for (var model in user.userModel!.savedModels!) {
        String? url = model.textPath;
        if (url != null) {
          Map<String, String>? data = await getJsonAsMapFromStorage(url);
          setState(() {
            jsonDataList.add(data);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserDataModel user = Provider.of<UserDataProvider>(context, listen: false).userDataModel;

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
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ...jsonDataList.asMap().entries.map((entry) {
            int index = entry.key;
            var data = entry.value;
            var path = user.userModel?.savedModels?[index].imagePath;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoScreen(data: data, path: path, index: index,),
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Image(
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  path ??
                                      'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data?['title'] ?? "Loading...",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              if (data != null)
                                ...data.entries.where((e) => e.key == 'text').map((e) => Text(e.value.substring(0,30) + '...' )).toList()
                              else
                                Text('Loading...'),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xff011928),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
