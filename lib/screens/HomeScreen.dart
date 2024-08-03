import 'package:flutter/material.dart';
import 'package:gardengru/data/navigationProvider.dart';
import 'package:provider/provider.dart';
import 'package:gardengru/data/userRecordProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider =
        Provider.of<userRecordProvider>(context, listen: false);
    if (!userProvider.isHomeScreenInitialized) {
      userProvider.initNewHomeScreen();
    }
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
                  _buildTopSection(provider),
                  const SizedBox(height: 16),
                  provider.isBottomHomeScreenLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildBottomSection(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopSection(userRecordProvider provider) {
    return Container(
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
          Text(
            provider.homeScreenDataModel!.getTitleForTop ??
                'Default Title for Top',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.homeScreenDataModel!.getTitle ?? 'Default Title',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildWidgetBox(
                  provider.homeScreenDataModel!.getWidgetDataModel!
                          .getWidgets ??
                      {'Default Key': 'Default Value'},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRiskBox(
                  provider.homeScreenDataModel!.getWidgetDataModel!.getRisks ??
                      {'Default Key': 'Default Value'},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false)
                    .setPageIndex(3);
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

  Widget _buildBottomSection(userRecordProvider provider) {
    return StreamBuilder<String>(
      stream: provider.articleStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading article...');
        } else if (snapshot.hasError) {
          return const Text('Error loading article');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No content available');
        } else {
          return Text(
            snapshot.data!,
            style: const TextStyle(fontSize: 16),
          );
        }
      },
    );
  }
}
