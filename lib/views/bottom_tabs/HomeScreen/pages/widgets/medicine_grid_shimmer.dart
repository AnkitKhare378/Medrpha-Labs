// medicine_grid_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays a shimmering loading grid for product cards.
class MedicineCardShimmer extends StatelessWidget {
  const MedicineCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the number of cards to show in the grid
    const int itemCount = 6; // Show 6 shimmer placeholders

    return GridView.builder(
      padding: const EdgeInsets.all(12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Matches the crossAxisCount in CompanyMedicineView
        childAspectRatio: 0.6, // Matches the childAspectRatio
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const _ShimmerProductCard();
      },
    );
  }
}

/// The individual shimmering product card placeholder.
class _ShimmerProductCard extends StatelessWidget {
  const _ShimmerProductCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer for Image Area
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1.2, // Matches ProductCard's AspectRatio
                child: Container(
                  color: Colors.white, // Shimmer base color will apply here
                ),
              ),
            ),
            // Shimmer for Details Area
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer for Product Name (Line 1)
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  // Shimmer for Product Name (Line 2 - partial width)
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),

                  // Shimmer for Price
                  Container(
                    height: 14,
                    width: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),

                  // Shimmer for Add Button
                  Container(
                    height: 28, // Matches the button height
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}