// lib/views/bottom_tabs/HomeScreen/widgets/medicine_detail_content/medicine_detail_content_and_ratings.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medrpha_labs/config/color/colors.dart';
import 'package:medrpha_labs/models/MedicineM/get_medicine_by_id_model.dart';

import '../widgets/test_detail_add_to_cart_button.dart';

class MedicineDetailContentAndRatings extends StatefulWidget {
  final GetMedicineByIdModel detail;

  const MedicineDetailContentAndRatings({super.key, required this.detail});

  @override
  State<MedicineDetailContentAndRatings> createState() => _MedicineDetailContentAndRatingsState();
}

class _MedicineDetailContentAndRatingsState extends State<MedicineDetailContentAndRatings> {
  // Omit _userId, _loadUserId, _fetchRatings, _hasUserRated for simplicity
  // since the new model doesn't have the necessary fields for rating logic.

  Widget _buildCouponContainer() {
    // ... (Your existing coupon container logic)
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        "Apply COUPON10 for 10% off!",
        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final discountedPrice = detail.salePrice;
    final originalPrice = detail.mrpPrice;
    double discountPercent = 0.0;
    if (originalPrice > discountedPrice) {
      discountPercent = ((originalPrice - discountedPrice) / originalPrice) * 100;
    }

    // Note: Removed ratingState and userHasRated as the required BLoCs/fields
    // for that logic are not available in this new medicine flow.

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Product Header ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder Image Container
                Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      // Use a placeholder or actual image URL if you have one
                      child: const Icon(Iconsax.box, color: AppColors.primaryColor, size: 40,),
                    )
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Use companyId as a proxy for category/department
                        "Company ID: ${detail.companyId}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detail.product, // Product Name
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Simple info chips based on available data
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoChipWidget("ID: ${detail.id}"),
                          _InfoChipWidget("Med ID: ${detail.medicineId}", icon: Iconsax.safe_home),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- Price section ---
            Row(
              children: [
                Text(
                  "₹${discountedPrice.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                if (originalPrice > discountedPrice)
                  Text(
                    "₹${originalPrice.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 8),
                if (discountPercent > 0)
                  Text(
                    "${discountPercent.toStringAsFixed(0)}% OFF",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.pink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TestDetailAddToCartButton(testDetail: null, packageDetail: null, medicineDetail: detail,),
            const SizedBox(height: 25),

            // --- Expiry Date ---
            Text(
              "Expiry Date",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Expires on: ${detail.expiry.toString().split(' ')[0]}",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // --- Coupons ---
            Text(
              "Coupons",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildCouponContainer(),
            const SizedBox(height: 25),

            // --- Provider Info ---
            Text(
              "Provided by",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              detail.company ?? "Unknown Company",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "MRP: ₹${detail.mrpPrice.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 40),

            // NOTE: Rating Section and Related Tests removed as the new model
            // doesn't support the required Ids (categoryId, testId) for them.
          ],
        ),
      ),
    );
  }
}


// Simple local InfoChipWidget for demonstration
class _InfoChipWidget extends StatelessWidget {
  final String text;
  final IconData icon;

  const _InfoChipWidget(this.text, {this.icon = Iconsax.info_circle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}