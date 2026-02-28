import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../view_model/BannerVM/get_all_banner_view_model.dart';

class SpecializedBanner extends StatelessWidget {
  const SpecializedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Standard host URL from your service
    const String imageHostUrl = 'https://www.online-tech.in/BannerImage/';

    return BlocBuilder<GetAllBannerBloc, GetAllBannerState>(
      builder: (context, state) {
        // Only render content if data is successfully loaded
        if (state is GetAllBannerLoaded) {
          // Filter for Category 2
          final category2Banners = state.banners
              .where((b) => b.bannerCategoryId == 2 && b.image != null && b.image!.isNotEmpty)
              .toList();

          // If no banners for this category, hide the section
          if (category2Banners.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Specialized Banners",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: category2Banners.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final banner = category2Banners[index];
                    final fullImageUrl = Uri.encodeFull('$imageHostUrl${banner.image}');

                    return SizedBox(
                      width: 150,
                      child: AspectRatio(
                        aspectRatio: 1 / 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            fullImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        // Return empty or Shimmer while loading
        return const SizedBox.shrink();
      },
    );
  }
}