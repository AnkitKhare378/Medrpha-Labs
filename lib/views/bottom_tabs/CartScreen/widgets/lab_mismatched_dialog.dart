import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../store/cart_notifier.dart'; // Adjust path to your CartProvider

class LabMismatchedDialog extends StatelessWidget {
  final CartProvider cartProvider;
  final int userId;
  final int productId;
  final String name;
  final int categoryId;
  final int labId;
  final String? labName;
  final double originalPrice;
  final double discountedPrice;

  const LabMismatchedDialog({
    super.key,
    required this.cartProvider,
    required this.userId,
    required this.productId,
    required this.name,
    required this.categoryId,
    required this.labId,
    this.labName,
    required this.originalPrice,
    required this.discountedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "Replace Cart?",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Text(
        "Your cart contains services from a different lab. Do you want to discard your current selection and add this service from ${labName ?? 'this lab'}?",
        style: GoogleFonts.poppins(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () async {
            Navigator.pop(context); // Close the dialog

            // Call the helper method we created in CartProvider
            await cartProvider.clearAndAdd(
              userId: userId,
              productId: productId,
              name: name,
              categoryId: categoryId,
              labId: labId,
              originalPrice: originalPrice,
              discountedPrice: discountedPrice,
            );
          },
          child: Text(
            "Discard & Add",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}