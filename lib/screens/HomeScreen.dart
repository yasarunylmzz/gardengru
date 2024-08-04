import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gardengru/data/userRecordProvider.dart';
import 'ListSavedItems.dart';

class HomeScreen extends StatefulWidget {
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

  void init(p) async{

    p.initUserData();
    if (!p.isHomeScreenInitialized) {
      await p.initHomeScreenWidget();
    }
   await p.setArticle();
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<userRecordProvider>(
        builder: (context, provider, child) {
          if (provider.isTopHomeScreenLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.homeScreenDataModel == null) {
            return const Center(child: Text('No data available'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            "what's happening in your garden today?",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Here are some widgets and risks for you to consider:",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildWidgetBox(provider
                                      .homeScreenDataModel!
                                      .getWidgetDataModel!
                                      .getWidgets ??
                                  {'Default Key': 'Default Value'}),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildRiskBox(provider.homeScreenDataModel!
                                      .getWidgetDataModel!.getRisks ??
                                  {'Default Key': 'Default Value'}),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListSavedItems()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("What's saved? "),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  provider.isBottomHomeScreenLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Text(provider.homeScreenDataModel!.getArticle),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${entry.key}: ${entry.value}',
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRiskBox(Map<String, String> risks) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: risks.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${entry.key}: ${entry.value}',
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
