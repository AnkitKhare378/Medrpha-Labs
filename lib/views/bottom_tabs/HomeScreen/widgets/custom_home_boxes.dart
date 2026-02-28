import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../view_model/BannerVM/get_all_banner_view_model.dart';

class CustomHomeBoxes extends StatelessWidget {
  const CustomHomeBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    const String imageHostUrl = 'https://www.online-tech.in/BannerImage/';
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final double imageHeight = isTablet ? 220 : 140;

    return BlocBuilder<GetAllBannerBloc, GetAllBannerState>(
      builder: (context, state) {
        if (state is GetAllBannerLoaded) {
          // Filter for Category 1
          final category1Banners = state.banners
              .where((b) => b.bannerCategoryId == 1 && b.image != null)
              .toList();

          if (category1Banners.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: category1Banners.map((banner) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        Uri.encodeFull('$imageHostUrl${banner.image}'),
                        height: imageHeight,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
        // Show nothing or a shimmer while loading
        return const SizedBox.shrink();
      },
    );
  }
}