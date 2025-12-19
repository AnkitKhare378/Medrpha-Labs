import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class PhotoUploadButton extends StatelessWidget {
  final VoidCallback onTap;

  const PhotoUploadButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              Iconsax.export,
              color: const Color(0xFF2196F3),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              'Upload Photo',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}