import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabOverviewSection extends StatelessWidget {
  const LabOverviewSection({super.key});

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
          Text("About this Lab",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "This diagnostic lab is accredited and provides trusted healthcare services, "
                "including blood tests, radiology scans, and preventive checkups.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class ReportDetailsSection extends StatelessWidget {
  const ReportDetailsSection({super.key});

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
          Text("Report Information",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "This report contains detailed test results including imaging/analysis. "
                "Consult your doctor for proper interpretation and next steps.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
