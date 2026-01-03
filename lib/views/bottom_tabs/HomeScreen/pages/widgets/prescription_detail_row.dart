// Helper widget for the prescription details
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrescriptionDetailRow extends StatelessWidget {
  final String text;
  final String label;
  final int number;

  const PrescriptionDetailRow({
    super.key,
    required this.text,
    required this.label,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dashed),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFe91e63), // Pink circle color
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}