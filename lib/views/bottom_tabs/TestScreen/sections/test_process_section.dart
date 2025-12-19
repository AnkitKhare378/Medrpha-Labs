import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestProcessSection extends StatelessWidget {
  const TestProcessSection({super.key});

  final String imageUrl =
      "https://plus.unsplash.com/premium_photo-1661434779070-cf8fc0e253ab?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bGFifGVufDB8fDB8fHww";

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        "title": "Step 1 - Vaccinated Phlebotomists",
        "desc": "Only vaccinated phlebos are assigned orders",
      },
      {
        "title": "Step 2 - Maintains Safety Precautions",
        "desc":
        "Phlebo wears the mask, face shield and gloves & sanitizes himself before visiting the location",
      },
      {
        "title": "Step 3 - Sample Collection",
        "desc":
        "Vaccinated Phlebotomists collects from syringe in the barcoded vials",
      },
      {
        "title": "Step 4 - Sample Storage",
        "desc":
        "Vials are placed in a cooling container to maintain the temperature",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How our test process works!",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),

        // Horizontal Scroller
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: steps.map((step) {
              return Container(
                width: 250,
                height: 200,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step["title"]!,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step["desc"]!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
