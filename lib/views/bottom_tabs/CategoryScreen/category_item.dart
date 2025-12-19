import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medrpha_labs/views/bottom_tabs/CategoryScreen/devices/device_page.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/color/colors.dart';
import '../../Dashboard/widgets/slide_page_route.dart';
import 'medicines/medicin_screen.dart' hide AppColors;

class CategoryItem {
  final String name;
  final String imageUrl;
  final Color backgroundColor;

  CategoryItem(this.name, this.imageUrl, this.backgroundColor);
}

Widget buildCategoryItem(CategoryItem item, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        SlidePageRoute(
          page: DevicePage(categoryName: item.name),
        ),
      );

    },
    child: Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: item.backgroundColor,
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
              item.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 75,
                    height: 75,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: item.backgroundColor,
                  child: Icon(
                    Iconsax.category,
                    color: AppColors.primaryColor,
                    size: 32,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 85,
          child: Text(
            item.name,
            style: GoogleFonts.poppins(
              fontSize: 7,
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}