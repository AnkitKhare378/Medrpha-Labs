import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<DateTime?> showDatePickerModal(BuildContext context, DateTime? initialDate) {
  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      DateTime? tempSelectedDate = initialDate;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Date of Birth',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFF2196F3),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF2196F3),
                        onSurface: Colors.black87,
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: initialDate ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      onDateChanged: (date) {
                        tempSelectedDate = date;
                        Navigator.pop(context, tempSelectedDate); // Return the selected date
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}