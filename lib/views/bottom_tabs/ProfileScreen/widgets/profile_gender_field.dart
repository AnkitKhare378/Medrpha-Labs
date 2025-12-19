import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileGenderField extends StatelessWidget {
  final String label;
  final String selectedGender;
  final VoidCallback onTap;

  const ProfileGenderField({
    super.key,
    required this.label,
    required this.selectedGender,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedGender.isEmpty ? 'Select Gender' : selectedGender,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: selectedGender.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
