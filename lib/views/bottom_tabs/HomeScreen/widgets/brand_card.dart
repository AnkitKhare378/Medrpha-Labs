import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/color/colors.dart';
import '../../../../data/repositories/medicine_service/category_medicine_service.dart';
import '../../../../models/BrandM/brand_model.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../pages/category_medicine_view.dart';

const String _imageHostUrl = 'https://www.online-tech.in/';

class BrandCard extends StatelessWidget {
  final BrandModel brand;

  const BrandCard({super.key, required this.brand});

  String get logoImageUrl => '$_imageHostUrl${brand.image.replaceAll('\\', '/')}';

  Color _getPlaceholderColor(int id) {
    final colors = [
      Colors.blue, Colors.pink, Colors.green, Colors.orange, Colors.purple,
      AppColors.primaryColor, Colors.red, Colors.amber,
    ];
    return colors[id % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final placeholderColor = _getPlaceholderColor(brand.id);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          SlidePageRoute(
            page: CategoryMedicineView(
              id: brand.id,
              title: brand.brandName,
              fetchType: MedicineFetchType.brand,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 💡 Use minimum space
          children: [
            // Brand Image Container
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                color: AppColors.white,
              ),
              child: ClipOval(
                child: Image.network(
                  logoImageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      backgroundColor: placeholderColor.withOpacity(0.2),
                      child: Text(
                        brand.brandName.isNotEmpty ? brand.brandName.substring(0, 1) : '?',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: placeholderColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 4), // 💡 Reduced from 8 to 4 to save space

            // 💡 Wrapped in Expanded to prevent overflow
            Expanded(
              child: SizedBox(
                width: 70,
                child: Text(
                  brand.brandName,
                  style: GoogleFonts.poppins(
                    fontSize: 11, // 💡 Slightly reduced font size for better fit
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}