import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../store/cart_notifier.dart';

class PaymentDetailsCard extends StatelessWidget {
  const PaymentDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    double mrpTotal = 0;
    double discountedTotal = 0;

    for (final item in cart.items.values) {
      final original = double.tryParse(item.originalPrice) ?? 0;
      final discounted = double.tryParse(item.discountedPrice) ?? 0;
      mrpTotal += original * item.qty;
      discountedTotal += discounted * item.qty;
    }

    final productDiscount = (mrpTotal - discountedTotal).clamp(0, double.infinity);
    const deliveryFee = 40.0;
    const platformFee = 10.0;
    final totalPayable = discountedTotal + deliveryFee + platformFee;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Payment Details",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildRow("MRP Total", "₹${mrpTotal.toStringAsFixed(2)}"),
            _buildRow("Product Discount", "-₹${productDiscount.toStringAsFixed(2)}",
                valueColor: Colors.green),
            _buildRow("Delivery Fee", "₹${deliveryFee.toStringAsFixed(2)}"),
            _buildRow("Platform Fee", "₹${platformFee.toStringAsFixed(2)}"),
            const Divider(height: 20),
            _buildRow("Total Payable", "₹${totalPayable.toStringAsFixed(2)}",
                isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w400)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                  color: valueColor ?? Colors.black)),
        ],
      ),
    );
  }
}
