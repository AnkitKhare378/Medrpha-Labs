import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BloodDescriptionSection extends StatelessWidget {
  const BloodDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info rows
          Row(
            children: [
              const Icon(Icons.water_drop, color: Colors.red),
              const SizedBox(width: 8),
              Text("Sample Type: Blood",
                  style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.no_food, color: Colors.orange),
              const SizedBox(width: 8),
              Text("Fasting Required: No",
                  style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.biotech, color: Colors.purple),
              const SizedBox(width: 8),
              Text("Tube Type: Edta",
                  style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),

          const Divider(height: 30, thickness: 1),

          // Description text
          Text(
            "Description",
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "ESR Test, or Erythrocyte Sedimentation Rate, is a blood test that can help detect inflammatory activity in the body. It helps with the diagnosis and monitoring of inflammatory problems. The ESR test may act as an indicator for conditions like unexplained fever, arthritis, vasculitis, acute and chronic infections, cancers and IBS. The test reports aid in detecting an existing medical condition and help doctors monitor inflammatory disease progress. Higher values of ESR do not always indicate an abnormality; it can be raised during pregnancy and increasing age. If ESR results are abnormal, doctors may further advise more specific tests to confirm the diagnosis. Individuals can take this test as recommended by their doctor.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
            textAlign: TextAlign.justify,
          ),
          // const SizedBox(height: 10),
          //
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: TextButton(
          //     onPressed: () {
          //       // For now no logic (just UI)
          //     },
          //     child: Text(
          //       "Show Less",
          //       style: GoogleFonts.poppins(
          //           color: Colors.blueAccent,
          //           fontWeight: FontWeight.w600),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
