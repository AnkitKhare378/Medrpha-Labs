import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressTypeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.blueAccent : Colors.black87,
        side: BorderSide(
          color: isSelected ? Colors.blueAccent : Colors.grey[400]!,
          width: 1.3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        backgroundColor:
        isSelected ? Colors.blueAccent.withOpacity(0.05) : Colors.white,
      ),
    );
  }
}
