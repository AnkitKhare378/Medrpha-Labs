import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Dashboard/widgets/slide_page_route.dart';
import 'lab_test_screen.dart';

class BloodTestScreen extends StatelessWidget {
  const BloodTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> bloodTests = [
      {
        'title': 'Complete Blood Count (CBC)',
        'description': 'Includes 24 parameters to check blood health',
        'price': '₹199'
      },
      {
        'title': 'Liver Function Test (LFT)',
        'description': 'Assesses liver enzymes and proteins',
        'price': '₹349'
      },
      {
        'title': 'Kidney Function Test (KFT)',
        'description': 'Checks creatinine, urea, uric acid etc.',
        'price': '₹299'
      },
      {
        'title': 'Thyroid Profile',
        'description': 'Includes T3, T4 and TSH tests',
        'price': '₹249'
      },
      {
        'title': 'Vitamin B12 & D Test',
        'description': 'Detects deficiency and supports immunity',
        'price': '₹399'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Blood Tests',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: bloodTests.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final test = bloodTests[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  SlidePageRoute(
                    page: LabTestDetailScreen(
                      title: test['title']!,
                      description: test['description']!,
                      price: test['price']!,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test['title']!,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      test['description']!,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Offer: ${test['price']}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade800,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Add booking logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Book Now',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
