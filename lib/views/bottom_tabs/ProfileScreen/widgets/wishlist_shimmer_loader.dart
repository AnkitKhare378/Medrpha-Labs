import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WishlistShimmerLoader extends StatelessWidget {
  const WishlistShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Show 5 placeholder cards
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white, // The color that will shimmer
              borderRadius: BorderRadius.circular(12),
            ),
            height: 120, // Height of a typical wishlist item card
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Placeholder for Title
                      Container(height: 12, width: double.infinity, color: Colors.white),
                      // Placeholder for Price
                      Container(height: 12, width: 80, color: Colors.white),
                      // Placeholder for Buttons
                      Container(height: 12, width: 150, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}