// TestScreen.dart
import 'package:flutter/material.dart';
import 'package:gardengru/data/fsConnection.dart';

class TestScreen extends StatelessWidget {
  final fsConnection _fsConnection = fsConnection();

  TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: StreamBuilder<List<String>>(
        stream: _fsConnection.getDocuments(
          'data', // Buraya koleksiyon adınızı girin
              (data, documentId) => documentId, // Sadece documentId'yi döndür
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]), // Document ID'yi göster
              );
            },
          );
        },
      ),
    );
  }
}
