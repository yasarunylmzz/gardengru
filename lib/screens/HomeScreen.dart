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
<<<<<<< Updated upstream
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
=======
        builder: (context, usr, child) {
          print("home screen");
          userRecord u = usr.user;
          print(
              "home screen watched and first textfilepath is ${u.savedItems?[0].textPath}");
          //print(u.savedItems?[0].textFileName);

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: u.savedItems?.length,
            itemBuilder: (context, index) {
              final textPath = u.savedItems?[index].textPath ?? '';
              // Debug: Print the URL
              print('Fetching data from URL: ${u.savedItems?[index].textPath}');

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
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
                                      const SizedBox(width: 12),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title ?? "Loading...",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            text != null
                                                ? '${text.substring(0, 30)}...'
                                                : 'Loading...',
                                            style:
                                                const TextStyle(fontSize: 14),
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
>>>>>>> Stashed changes
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
