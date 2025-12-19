import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import the package

class TestDetailShimmer extends StatelessWidget {
  const TestDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (Image and Title)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for Image/Icon
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placeholder for Category
                      _buildPlaceholderLine(width: 100),
                      const SizedBox(height: 8),
                      // Placeholder for Test Name
                      _buildPlaceholderLine(width: double.infinity),
                      const SizedBox(height: 4),
                      _buildPlaceholderLine(width: 250),
                      const SizedBox(height: 16),
                      // Placeholder for Info Chips (2 rows)
                      Row(
                        children: [
                          _buildPlaceholderChip(width: 80),
                          const SizedBox(width: 8),
                          _buildPlaceholderChip(width: 120),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildPlaceholderChip(width: 100),
                          const SizedBox(width: 8),
                          _buildPlaceholderChip(width: 90),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Price Section Placeholder
            Row(
              children: [
                _buildPlaceholderLine(width: 70, height: 20),
                const SizedBox(width: 16),
                _buildPlaceholderLine(width: 60, height: 16),
              ],
            ),
            const SizedBox(height: 16),

            // Add to Cart Button Placeholder
            _buildPlaceholderLine(
              width: double.infinity,
              height: 50,
              borderRadius: 12,
            ),
            const SizedBox(height: 30),

            // Description Placeholder
            _buildPlaceholderLine(width: 150),
            const SizedBox(height: 12),
            _buildPlaceholderLine(width: double.infinity),
            _buildPlaceholderLine(width: double.infinity),
            _buildPlaceholderLine(width: 200),
            const SizedBox(height: 30),

            // Other Sections Placeholder
            _buildPlaceholderLine(width: 180),
            const SizedBox(height: 8),
            _buildPlaceholderLine(width: 150),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderLine({
    required double width,
    double height = 14,
    double borderRadius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // Color to be shimmered
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildPlaceholderChip({required double width}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: _buildPlaceholderLine(width: width, height: 12),
    );
  }
}