import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/models/BrandM/brand_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/color/colors.dart';
import 'category_page.dart' hide AppColors;

class PopularProducts extends StatelessWidget {
  final BrandModel brand;

  const PopularProducts({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    // 💡 Construct the full image URL
    final String fullImageUrl = 'https://www.online-tech.in/${brand.image}';

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              // 💡 Use the new full image URL
              fullImageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(width: 80, height: 80, color: Colors.white),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // Optional: Display an icon or placeholder on error
                return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            brand.brandName,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}