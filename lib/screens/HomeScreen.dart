import 'package:flutter/material.dart';
import 'package:gardengru/data/navigationProvider.dart';
import 'package:provider/provider.dart';
import 'package:gardengru/data/userRecordProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final userProvider =
        Provider.of<userRecordProvider>(context, listen: false);
    init(userProvider);
  }

  void init(userRecordProvider provider) async {
    await provider.initUserData();
    if (!provider.isHomeScreenInitialized) {
      await provider.initHomeScreenWidget();
    }
    await provider.setArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<userRecordProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF578D7C),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "What's happening in your garden today?",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Here are some widgets and risks for you to consider:",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: _buildWidgetBox(provider
                                        .homeScreenDataModel
                                        ?.getWidgetDataModel
                                        ?.getWidgets ??
                                    {'': ''}),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: _buildRiskBox(provider
                                        .homeScreenDataModel
                                        ?.getWidgetDataModel
                                        ?.getRisks ??
                                    {'': ''}),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {
                              Provider.of<NavigationProvider>(context,
                                      listen: false)
                                  .setPageIndex(2);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Colors.teal, width: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              elevation: 5, // shadow effect
                            ),
                            child: const Text(
                              "What's saved?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF578D7C),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      provider.homeScreenDataModel?.getArticle
                              ?.replaceAll(RegExp(r'\*{2}|\#{2}|\*'), ' ') ??
                          'Loading...',
                    ),
                  ),
                  const SizedBox(
                      height: 80), // Add padding to avoid bottom bar overlap
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWidgetBox(Map<String, String> widgets) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: widgets.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${entry.key}: ${entry.value}',
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRiskBox(Map<String, String> risks) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: risks.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${entry.key}: ${entry.value}',
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }
}
