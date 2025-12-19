import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
// Assuming 'medrpha_labs/config/color/colors.dart' is the correct path for AppColors
import 'package:medrpha_labs/config/color/colors.dart';

import '../../../../models/PackagesM/package_detail_model.dart';
import 'related_test_slider.dart';
import 'test_detail_add_to_cart_button.dart';

// --- Search Bar Widget ---

class PackageDetailSearchBar extends StatelessWidget {
  const PackageDetailSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search for",
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            hintStyle: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      ),
    );
  }
}

// --- Main Content Widget (Loaded State) ---

class PackageDetailLoadedContent extends StatelessWidget {
  final PackageDetailModel detail;

  const PackageDetailLoadedContent({super.key, required this.detail});

  // Helper method for the info chips
  Widget _infoChip(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Helper method for the coupon container
  Widget _buildCouponContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Flat ₹700 off on all lab tests & packages\nMin cart value: ₹3000",
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Unlock",
              style: GoogleFonts.poppins(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double discountPercent = detail.totalPrice > 0
        ? (detail.discountPrice / detail.totalPrice) * 100
        : 0;

    final double finalPrice = detail.packagePrice;
    final double strikedPrice = detail.totalPrice;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Test Header Info ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.science,
                    size: 40, color: Colors.blueAccent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.labName ?? detail.companyName ?? "Lab Provider",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail.packageName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (detail.isPopular) _infoChip("Popular Package"),
                        _infoChip("${detail.packageTests.length} Tests Included",
                            icon: Icons.science),
                        if (detail.isFasting)
                          _infoChip("Fasting Required", icon: Iconsax.warning_2),
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
                "₹${finalPrice.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "₹${strikedPrice.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
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

          TestDetailAddToCartButton(testDetail: null, packageDetail: detail,),

          const SizedBox(height: 25),

          // --- Description Section ---
          Text(
            "Package Description",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail.description,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 25),
          const Divider(),

          // --- Included Tests Section ---
          Text(
            "Tests Included in Package",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...detail.packageTests.map((test) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    test.testName,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
                Text(
                  "₹${test.testPriceInPackage.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )),
          const SizedBox(height: 25),

          // --- Coupons Section ---
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

          // --- Test Provider Info ---
          Text(
            "Test provided by",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            detail.companyName ?? detail.labName ?? "Default Lab",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 15),

          // --- Sample Collection Info ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sample Test Collection",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                      text: TextSpan(
                          text: '226005   ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Lucknow, Uttar Pradesh',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black26,
                              ),
                            )
                          ])),
                ],
              ),
              Icon(
                Icons.edit,
                color: AppColors.primaryColor,
              )
            ],
          ),
          const SizedBox(height: 25),
          const Divider(),
          RelatedTestsSlider(testId: detail.packageId,),
        ],
      ),
    );
  }
}