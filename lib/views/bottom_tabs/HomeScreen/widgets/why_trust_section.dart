import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhyTrustMedrPha extends StatelessWidget {
  const WhyTrustMedrPha({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> trustPoints = [
      {
        'icon': Icons.biotech_rounded,
        'title': 'Clinical Precision',
        'subtitle': 'NABL & ISO standard testing',
        'color': Colors.blue,
      },
      {
        'icon': Icons.timer_outlined,
        'title': 'Punctual Service',
        'subtitle': 'On-time sample collection',
        'color': Colors.green,
      },
      {
        'icon': Icons.badge_outlined,
        'title': 'Expert Phlebotomists',
        'subtitle': 'Certified lab professionals',
        'color': Colors.purple,
      },
      {
        'icon': Icons.clean_hands_rounded,
        'title': 'Safety First',
        'subtitle': '100% hygienic & sealed kits',
        'color': Colors.orange,
      },
      {
        'icon': Icons.description_outlined,
        'title': 'Smart Reports',
        'subtitle': 'Easy to understand results',
        'color': Colors.pink,
      },
      {
        'icon': Icons.headset_mic_outlined,
        'title': 'Expert Support',
        'subtitle': 'Dedicated health assistants',
        'color': Colors.teal,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Why Indians trust',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'MedrPha Labs',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue[900],
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Grid of trust cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trustPoints.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3, // Adjust for card height
          ),
          itemBuilder: (context, index) {
            final point = trustPoints[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with soft background
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: point['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      point['icon'],
                      color: point['color'],
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    point['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    point['subtitle'],
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[500],
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}