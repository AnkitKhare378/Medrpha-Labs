import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CategoryScreen/category_page.dart';
import '../pages/search_detail_page.dart';
import '../pages/upload_percription_page.dart';

class PrescriptionCardsSection extends StatelessWidget {
  const PrescriptionCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          // Card 1: Have a prescription?
          PrescriptionCard(
            title: 'Have a\nprescription?',
            subtitle: 'Simply upload and we will help place order on your behalf.',
            buttonText: 'Upload',
            buttonColor: Colors.blue.shade400,
            onTap: () {
              Navigator.of(context).push(
                SlidePageRoute(page: const UploadPrescriptionPage()),
              );
            },
          ),

          // Card 2: Continue shopping (The "Check" button)
          PrescriptionCard(
            title: 'Continue\nshopping for',
            subtitle: 'Medrpha Labs',
            buttonText: 'Check',
            buttonColor: Colors.orange.shade600,
            onTap: () {
              // Navigates to your Dashboard Category Page
              Navigator.of(context).push(
                SlidePageRoute(page: const CategoryPage()),
              );

              // Temporary feedback to confirm it works
              debugPrint("Navigating to Category Page...");
            },
          ),
        ],
      ),
    );
  }
}

/// A generic card widget that accepts an onTap function for navigation
class PrescriptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onTap;

  const PrescriptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      margin: const EdgeInsets.only(right: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: onTap, // Executes the specific logic passed from parent
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

