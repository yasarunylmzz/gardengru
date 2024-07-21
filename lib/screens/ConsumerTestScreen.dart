import 'package:flutter/material.dart';
import 'package:gardengru/data/records/userRecord.dart';
import 'package:provider/provider.dart';
// Import the value_notifier.dart file
import 'package:gardengru/data/userRecordProvider.dart';

class ConsumerTestScreen extends StatelessWidget {
  const ConsumerTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Value List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<userRecordProvider>(
              builder: (context, usr, child) {
                userRecord u = usr.user;
                print(u.savedItems?[0].textFileName);
                return ListView.builder(
                  itemCount: u.savedItems?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(u.savedItems?[index].textFileName ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {

                Provider.of<userRecordProvider>(context, listen: false).forceNotify();
              },
              child: Text('Add Value'),
            ),
          ),
        ],
      ),
    );
  }
}