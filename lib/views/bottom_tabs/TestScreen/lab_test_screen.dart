import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sections/blood_description_section.dart';
import 'sections/easer_overview_section.dart';
import 'sections/test_process_section.dart';

class LabTestDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String price;

  const LabTestDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // First container (basic details)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Price: $price",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.green.shade800)),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Booking logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Book Test",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BloodDescriptionSection(),
            const SizedBox(height: 20),
            TestProcessSection(),
            const SizedBox(height: 20),
            EserOverviewSection(),
          ],
        ),
      ),
    );
  }
}
