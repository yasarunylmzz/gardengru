import 'package:flutter/material.dart';

void main() {
  runApp(InfoScreen());
}

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Identifier'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.network(
                  'https://images.theconversation.com/files/275002/original/file-20190516-69195-1yg53ff.jpg?ixlib=rb-4.1.0&q=20&auto=format&w=320&fit=clip&dpr=2&usm=12&cs=strip', // Resim URL'nizi buraya ekleyin
                  fit: BoxFit.cover,
                  height: 300,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Arenosol Soil',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'From Wikipedia, the free encyclopedia\n\nPapaver somniferum, commonly known as the opium poppy or breadseed poppy, is a species of flowering plant in the family Papaveraceae. It is the species of plant from which both opium and poppy seeds are derived.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          _buildPlantInfo(
                              'Drainage',
                              'Well-drained',
                              Icon(Icons.water_damage),
                              Colors.green,
                              Colors.black),
                          const SizedBox(height: 16),
                          _buildPlantInfo(
                              'Nutrients',
                              'Low',
                              Icon(Icons.eco_outlined),
                              Colors.red,
                              Colors.black),
                        ],
                      ),
                      Column(
                        children: [
                          _buildPlantInfo(
                              'Texture',
                              'Sandy',
                              Icon(Icons.texture_outlined),
                              Colors.red,
                              Colors.black),
                          const SizedBox(height: 16),
                          _buildPlantInfo(
                            'Color',
                            'Light Brown',
                            Icon(Icons.color_lens_outlined),
                            Colors.brown,
                            Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantInfo(
      String title, String value, Icon icon, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(8.0), // Adding padding for better spacing
      decoration: BoxDecoration(
        color: Colors.white, // Background color for the container
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: bgColor, // Background color for the icon container
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: icon, // Center the icon within the container
            ),
          ),
          const SizedBox(height: 8), // Add spacing between icon and text
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor, // Text color
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.black, // Default text color for value
            ),
          ),
        ],
      ),
    );
  }
}
