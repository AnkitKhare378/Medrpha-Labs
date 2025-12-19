import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Dashboard/widgets/slide_page_route.dart';
import '../pages/search_detail_page.dart';
import '../pages/upload_percription_page.dart';

class PrescriptionCardsSection extends StatelessWidget {
  const PrescriptionCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // We omit the Dot Indicator here for brevity, assuming it's handled elsewhere
    return SizedBox(
      height: 195, // Explicit height for the horizontal ListView
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          // Card 1: No prescription? (Not the upload card)
          const PrescriptionCard(
            title: 'No prescription?\nNo problem!',
            subtitle: 'Place order & get\nFree Doctor Consultation call in 5 mins!',
            buttonText: 'Order now',
            buttonColor: Color(0xFF2ecc71),
            isUploadCard: false,
          ),
          // Card 2: Have a prescription? (This is the upload card)
          PrescriptionCard(
            title: 'Have a\nprescription?',
            subtitle: 'Simply upload and we will help place order on your behalf.',
            buttonText: 'Upload',
            buttonColor: Colors.blue.shade400,
            isUploadCard: true, // Set to true to enable navigation
          ),
          // Card 3: Continue shopping
          PrescriptionCard(
            title: 'Continue\nshopping for',
            subtitle: 'Medrpha Labs',
            buttonText: 'Check',
            buttonColor: Colors.orange.shade600,
            isUploadCard: false,
          ),
        ],
      ),
    );
  }
}

/// Widget for the horizontal scrolling cards (Prescription/Order).
class PrescriptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color buttonColor;
  final bool isUploadCard; // New flag to distinguish the upload card

  const PrescriptionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonColor,
    this.isUploadCard = false, // Default is false
  }) : super(key: key);

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
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: () {
                if (isUploadCard) {
                  Navigator.of(context).push(
                    SlidePageRoute(page: const UploadPrescriptionPage()),
                  );
                } else {
                  // Handle other button taps (e.g., 'Order now')
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 0),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

