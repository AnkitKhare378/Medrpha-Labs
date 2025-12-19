import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthCategoryScroller extends StatelessWidget {
  const HealthCategoryScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'label': 'Full body Checkup',
        'icon': Icons.medical_information,
        'color': Colors.blue.shade50,
      },
      {
        'label': "Women's Health",
        'icon': Icons.female,
        'color': Colors.pink.shade50,
      },
      {
        'label': "Men's Health",
        'icon': Icons.male,
        'color': Colors.green.shade50,
      },
      {
        'label': "Senior Citizens",
        'icon': Icons.elderly,
        'color': Colors.orange.shade50,
      },
      {
        'label': "Kids Health",
        'icon': Icons.child_care,
        'color': Colors.purple.shade50,
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: 110,
            decoration: BoxDecoration(
              color: category['color'],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'],
                  size: 36,
                  color: Colors.black87,
                ),
                const SizedBox(height: 8),
                Text(
                  category['label'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
