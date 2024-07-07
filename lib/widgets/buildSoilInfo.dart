import 'package:flutter/material.dart';

class buildSoilInfo extends StatelessWidget {
  const buildSoilInfo({
    super.key,
    required this.context,
    required this.title,
    required this.value,
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });

  final BuildContext context;
  final String title;
  final String value;
  final Icon icon;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0), // Adding padding for better spacing
      width: MediaQuery.of(context).size.width *
          0.4, // Adjust width based on screen size
      decoration: BoxDecoration(
        color: Colors.white, // Background color for the container
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width *
                0.1, // Adjust icon container width based on screen size
            height: MediaQuery.of(context).size.width *
                0.1, // Adjust icon container height based on screen size
            decoration: BoxDecoration(
              color: bgColor, // Background color for the icon container
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: icon, // Center the icon within the container
            ),
          ),
          const SizedBox(width: 8), // Add spacing between icon and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                style: const TextStyle(
                  color: Colors.black, // Default text color for value
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
