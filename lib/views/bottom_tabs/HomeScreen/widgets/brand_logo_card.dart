// File: lib/pages/dashboard/widgets/brand_logo_card.dart (New File)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/color/colors.dart';
import '../../../../models/BrandM/brand_model.dart';

// Assuming the image host URL is the base API URL
const String _imageHostUrl = 'https://www.online-tech.in/';

class BrandLogoCard extends StatelessWidget {
  final BrandModel brand;

  const BrandLogoCard({super.key, required this.brand});

  String get fullImageUrl => '$_imageHostUrl${brand.image.replaceAll('\\', '/')}';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Brand Image Container (Logo)
        Container(
          width: 70,
          height: 70,
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
              fullImageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.error_outline, color: Colors.red),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(width: 70, height: 70, color: Colors.white),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Brand Name Text
        SizedBox(
          width: 70,
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