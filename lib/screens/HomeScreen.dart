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
    final userProvider = Provider.of<userRecordProvider>(context, listen: false);
    if (!userProvider.isHomeScreenInitialized) {
      userProvider.initNewHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Consumer<userRecordProvider>(
        builder: (context, provider, child) {
          if (provider.isTopHomeScreenLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.homeScreenDataModel == null) {
            return Center(child: Text('No data available'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.homeScreenDataModel!.getTitleForTop ?? '',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          provider.homeScreenDataModel!.getTitle ?? '',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildWidgetBox(provider.homeScreenDataModel!.getWidgetDataModel!.getWidgets),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildRiskBox(provider.homeScreenDataModel!.getWidgetDataModel!.getRisks),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListSavedItems()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
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
                  SizedBox(height: 16),
                  provider.isBottomHomeScreenLoading
                      ? Center(child: CircularProgressIndicator())
                      : StreamBuilder<String>(
                    stream: provider.articleStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading article...');
                      } else if (snapshot.hasError) {
                        return Text('Error loading article');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No content available');
                      } else {
                        return Text(
                          snapshot.data!,
                          style: TextStyle(fontSize: 16),
                        );
                      }
                    },
                  ),
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
      padding: EdgeInsets.all(16),
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
              style: TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRiskBox(Map<String, String> risks) {
    return Container(
      padding: EdgeInsets.all(16),
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
              style: TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
