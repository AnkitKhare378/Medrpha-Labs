import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String?> showGenderPickerModal(BuildContext context, String currentGender) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      const List<String> genders = ['Male', 'Female', 'Other'];
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Gender',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ...genders.map((gender) => GestureDetector(
              onTap: () => Navigator.pop(context, gender), // Return the selected gender
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: currentGender == gender
                      ? const Color(0xFF2196F3).withOpacity(0.1)
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: currentGender == gender
                        ? const Color(0xFF2196F3)
                        : Colors.blue.shade100,
                  ),
                ),
                child: Text(
                  gender,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: currentGender == gender
                        ? const Color(0xFF2196F3)
                        : Colors.black87,
                  ),
                ),
              ),
            )),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}