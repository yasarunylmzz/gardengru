import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gardengru/data/dataModels/HomeScreenDataModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../data/helpers/StorageHelper.dart';
import '../data/userRecordProvider.dart';
import '../data/records/userRecord.dart';
import 'InfoScreen.dart';

class ListSavedItems extends StatefulWidget {
  const ListSavedItems({super.key});

  @override
  State<ListSavedItems> createState() => _ListSavedItemsState();
}

class _ListSavedItemsState extends State<ListSavedItems> {
  @override
  void initState() {
    super.initState();
   // final userProvider =
   // Provider.of<userRecordProvider>(context, listen: false);
    //userProvider.initLogged();
  }

  Future<void> _refreshData() async {
    final userProvider =
    Provider.of<userRecordProvider>(context, listen: false);
    userProvider.setIsInitialized(
        false); // Ensure this method sets _isInitialized to false
    await userProvider.initLogged();
  }

  @override
  Widget build(BuildContext context) {
    final StorageHelper storageHelper = StorageHelper();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Home'),
        ),
      ),
      body: Consumer<userRecordProvider>(
        builder: (context, usrProvider, child) {
          if (usrProvider.isLoading) {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: 10, // Number of loading placeholders
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 150,
                                  height: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          List<Map<String, String>?> dataList = usrProvider.listSavedItemScreenData;
          userRecord u = usrProvider.user;


          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final dataMap = dataList[index];
                final title = dataMap?['title']?.replaceAll(RegExp(r'^##'), '');
                final text = dataMap?['text'];
                final imagePath = u.getsaved?[index].getimagePath;

                return Dismissible(
                  key: Key(index.toString()),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    storageHelper.DeleteSavedItemFromStorageAndStore(u, index);
                    context
                        .read<userRecordProvider>()
                        .removeSavedItemSilently(index);
                  },
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
                            offset: const Offset(0, 2),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            const Icon(Icons.arrow_forward_ios,
                                color: Color(0xff011928)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}