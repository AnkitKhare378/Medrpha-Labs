import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart'; // Still useful for the background if needed
import 'dart:math';

// Assuming these paths are correct
import '../../../../config/color/colors.dart';
import '../../../../models/BrandM/brand_model.dart';
// ⚠️ You must create the BrandStoryPage file at this path:
import '../pages/brand_story_page.dart';

// Assuming the image host URL is the base API URL
const String _imageHostUrl = 'https://www.online-tech.in/';

class BrandCard extends StatelessWidget {
  final BrandModel brand;

  const BrandCard({super.key, required this.brand});

  // Logo URL for the circle/story card
  String get logoImageUrl => '$_imageHostUrl${brand.image.replaceAll('\\', '/')}';

  // Assuming the story image is the same for this implementation,
  // but you can change this if BrandModel had a separate 'storyImage' field.
  String get storyImageUrl => logoImageUrl;

  // Simple function to generate a consistent placeholder color based on Brand ID
  Color _getPlaceholderColor(int id) {
    // Generate a color from a fixed list or a hash
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
        // 💡 Implement Navigation to BrandStoryPage
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BrandStoryPage(
              brandName: brand.brandName,
              // Pass the BrandModel to the story page if needed, but using required fields
              imageUrl: storyImageUrl,
            ),
          ),
        );
      },
      child: Padding(
        // Padding for separation in the horizontal list
        padding: const EdgeInsets.only(right: 12.0),
        child: Column(
          children: [
            // Brand Image Container (Circular Story UI)
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Optional: Add a subtle border like a 'story' ring
                border: Border.all(color: Colors.grey.shade300, width: 1),
                color: AppColors.white,
              ),
              child: ClipOval(
                child: Image.network(
                  logoImageUrl,
                  fit: BoxFit.contain,

                  // 💡 Loading Builder (Placeholder logic)
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    // Show Shimmer while loading image
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        backgroundColor: placeholderColor.withOpacity(0.2),
                      ),
                    );
                  },

                  // 💡 Error Builder (Placeholder logic)
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      backgroundColor: placeholderColor.withOpacity(0.2),
                      child: Text(
                        // Get the first letter of the brand name
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
        ),
      ),
    );
  }
}