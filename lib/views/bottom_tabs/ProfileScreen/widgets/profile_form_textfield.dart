import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileFormTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  // 1. New property for keyboard type
  final TextInputType keyboardType;
  // 2. New property for read-only state
  final bool readOnly;

  const ProfileFormTextField({
    super.key,
    required this.label,
    required this.controller,
    // Set a default keyboard type (text)
    this.keyboardType = TextInputType.text,
    // Set a default read-only state
    this.readOnly = false,
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
          TextFormField(
            controller: controller,
            // 3. Pass the keyboardType property
            keyboardType: keyboardType,
            // 4. Pass the readOnly property and disable interaction if readOnly
            readOnly: readOnly,
            enabled: !readOnly, // Visually disable the field if read-only

            style: GoogleFonts.poppins(
              fontSize: 16,
              color: readOnly ? Colors.grey : Colors.black87, // Change text color for read-only
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              // Optional: Add a subtle visual hint for read-only fields
              disabledBorder: readOnly
                  ? UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}