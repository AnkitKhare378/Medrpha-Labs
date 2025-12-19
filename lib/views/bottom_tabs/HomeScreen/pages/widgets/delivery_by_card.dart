import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryByCard extends StatelessWidget {
  final String dateTime; // e.g., "01:30 PM, Today"

  const DeliveryByCard({
    super.key,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.delivery_dining, size: 28, color: Colors.blueAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Delivery by $dateTime",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
