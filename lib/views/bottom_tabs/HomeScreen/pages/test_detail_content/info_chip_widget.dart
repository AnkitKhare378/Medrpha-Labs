// lib/views/bottom_tabs/HomeScreen/widgets/test_detail_content/_info_chip_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoChipWidget extends StatelessWidget {
  final String text;
  final IconData? icon;

  const InfoChipWidget(this.text, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}