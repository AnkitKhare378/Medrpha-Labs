import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionTabs extends StatelessWidget {
  const TransactionTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blueAccent,
              side: const BorderSide(color: Colors.blueAccent),
            ),
            child: Text('Medr Cash',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 12)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blueAccent,
              side: const BorderSide(color: Colors.blueAccent),
            ),
            child: Text('Medr Supercash',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 12)),
          ),
        ),
      ],
    );
  }
}
