import 'package:flutter/material.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:provider/provider.dart';
// Import the value_notifier.dart file
import 'package:gardengru/data/userRecordProvider.dart';

class ConsumerTestScreen extends StatefulWidget {
  const ConsumerTestScreen({super.key});

  @override
  _ConsumerTestScreenState createState() => _ConsumerTestScreenState();
}

class _ConsumerTestScreenState extends State<ConsumerTestScreen> {
  userRecord? _userRecord;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch the data here
    _fetchData();
  }

  void _fetchData() {
    // Get the userRecordProvider from the context
    final usrProvider = Provider.of<userRecordProvider>(context, listen: false);
    setState(() {
      _userRecord = usrProvider.user;
    });
    print(_userRecord?.savedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Value List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _userRecord?.savedItems?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_userRecord?.savedItems?[index].textFileName ??
                      'No Items'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Provider.of<userRecordProvider>(context, listen: false)
                    .forceNotify();
                _fetchData(); // Refresh the data
              },
              child: Text('Add Value'),
            ),
          ),
        ],
      ),
    );
  }
}
