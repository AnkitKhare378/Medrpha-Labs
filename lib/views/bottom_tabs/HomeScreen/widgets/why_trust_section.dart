import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhyTrustMedrPha extends StatelessWidget {
  const WhyTrustMedrPha({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final List<Map<String, dynamic>> trustPoints = [
      {
        'icon': Icons.verified_user,
        'text': '100% Accurate Reports',
        'colors': [Colors.blueAccent, Colors.lightBlueAccent],
      },
      {
        'icon': Icons.schedule,
        'text': 'On-time Sample Collection',
        'colors': [Colors.green, Colors.lightGreenAccent],
      },
      {
        'icon': Icons.health_and_safety,
        'text': 'Certified Lab Technicians',
        'colors': [Colors.purple, Colors.deepPurpleAccent],
      },
      {
        'icon': Icons.local_hospital,
        'text': 'N.A.B.L. Certified Labs',
        'colors': [Colors.orange, Colors.deepOrangeAccent],
      },
      {
        'icon': Icons.security,
        'text': 'Safe & Hygienic Process',
        'colors': [Colors.pink, Colors.pinkAccent],
      },
      {
        'icon': Icons.support_agent,
        'text': '24x7 Customer Support',
        'colors': [Colors.teal, Colors.tealAccent],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        RichText(
          text: TextSpan(
            text: 'Why Indians trust ',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: 'MedrPha Labs',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueAccent, // Optional: highlight the brand
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Grid of cards
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: trustPoints.map((point) {
            return Container(
              width: (screenWidth - 48) / 2, // 16 + 16 padding + 12 spacing
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: point['colors'],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    point['icon'],
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    point['text'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
