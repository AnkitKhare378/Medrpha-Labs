import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMoreTestButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  const AddMoreTestButton({super.key, required this.onPressed, required this.title, required this.backgroundColor, required this.textColor, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // ✅ Full width
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? Colors.grey.shade400),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        label: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
