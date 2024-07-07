import 'package:flutter/material.dart';
import 'package:gardengru/widgets/buildSoilInfo.dart';

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
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          buildSoilInfo(
                              context: context,
                              title: 'Drainage',
                              value: 'Well-drained',
                              icon: const Icon(
                                Icons.water_damage,
                                color: Color(0xff4B8364),
                              ),
                              bgColor: Colors.lightGreen.shade100,
                              textColor: Colors.green),
                          const SizedBox(height: 16),
                          buildSoilInfo(
                              context: context,
                              title: 'Nutrients',
                              value: 'Low',
                              icon: const Icon(Icons.eco_outlined,
                                  color: Color(0XFF7C95E4)),
                              bgColor: const Color(0xFFE6EAFA),
                              textColor: const Color(0xff5676DC)),
                        ],
                      ),
                      Column(
                        children: [
                          buildSoilInfo(
                              context: context,
                              title: 'Texture',
                              value: 'Sandy',
                              icon: const Icon(
                                Icons.texture_outlined,
                                color: Color(0xffE6B44C),
                              ),
                              bgColor: const Color(0xffFCF1E3),
                              textColor: const Color(0xffEAC069)),
                          const SizedBox(height: 16),
                          buildSoilInfo(
                              context: context,
                              title: 'Color',
                              value: 'Light Brown',
                              icon: const Icon(
                                Icons.color_lens_outlined,
                                color: Color(0xffA559D9),
                              ),
                              bgColor: const Color(0xffF8E8F8),
                              textColor: const Color(0xffC390E6)),
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
}
