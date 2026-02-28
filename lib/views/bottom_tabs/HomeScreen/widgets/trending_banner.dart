import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../view_model/BannerVM/get_all_banner_view_model.dart';

class TrendingBanner extends StatelessWidget {
  const TrendingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const String imageHostUrl = 'https://www.online-tech.in/BannerImage/';

    return BlocBuilder<GetAllBannerBloc, GetAllBannerState>(
      builder: (context, state) {
        if (state is GetAllBannerLoaded) {
          // Filter for Category 4 (Trending Today)
          final trendingBanners = state.banners
              .where((b) =>
          b.bannerCategoryId == 4 &&
              b.image != null &&
              b.image!.isNotEmpty)
              .toList();

          // Hide the section if no banners exist for this category
          if (trendingBanners.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Trending Today",
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
                  itemCount: trendingBanners.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final banner = trendingBanners[index];
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
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
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

        // Return shrink or a specific shimmer if loading
        return const SizedBox.shrink();
      },
    );
  }
}