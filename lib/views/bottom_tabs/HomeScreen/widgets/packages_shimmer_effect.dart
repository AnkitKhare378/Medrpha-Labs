import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PackageShimmerEffect extends StatelessWidget {
  const PackageShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double cardWidth = screenWidth * 0.43;
    final double cardHeight = screenHeight * 0.24;
    final double bookNowHeight = screenHeight * 0.05;

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Show a few placeholder items
        itemBuilder: (context, index) {
          return Container(
            width: cardWidth,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Placeholder
                        Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 8),
                        ),
                        Container(
                          width: cardWidth * 0.7,
                          height: 14,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 6),
                        ),
                        // Test Count Placeholder
                        Container(
                          width: cardWidth * 0.5,
                          height: 12,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 15),
                        ),
                        // Offer Placeholder
                        Container(
                          width: cardWidth * 0.75,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // "Book Now" Button Placeholder
                  Container(
                    height: bookNowHeight,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white, // White color for shimmer effect
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}