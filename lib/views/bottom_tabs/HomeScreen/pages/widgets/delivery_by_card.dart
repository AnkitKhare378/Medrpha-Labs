import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Ensure you have intl in pubspec.yaml

class DeliveryByCard extends StatelessWidget {
  final String orderTime;
  final String orderDate;

  const DeliveryByCard({
    super.key,
    required this.orderTime,
    required this.orderDate,
  });

  // Helper to format Time (04:00:00 -> 04:00 AM)
  String _formatTime(String time) {
    if (time.isEmpty) return "N/A";
    try {
      // Parsing "HH:mm:ss"
      DateTime tempDate = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(tempDate);
    } catch (e) {
      return time; // Fallback
    }
  }

  // Helper to format Date (2026-03-10T... -> 10-03-26)
  String _formatDate(String date) {
    if (date.isEmpty) return "N/A";
    try {
      DateTime tempDate = DateTime.parse(date);
      return DateFormat("dd-MM-yy").format(tempDate);
    } catch (e) {
      return date; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayTime = _formatTime(orderTime);
    String displayDate = _formatDate(orderDate);

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.blueAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Scheduled Slot",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    "$displayDate at $displayTime",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}