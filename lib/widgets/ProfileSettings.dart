import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSettings extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  const ProfileSettings({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.workSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.workSans(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
