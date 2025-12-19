// --- Shimmer Placeholder Widget ---
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PackageDetailShimmer extends StatelessWidget {
  const PackageDetailShimmer({super.key});

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
                _buildPlaceholderBox(height: 70, width: 70, borderRadius: 10),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPlaceholderLine(width: 120),
                      const SizedBox(height: 8),
                      _buildPlaceholderLine(width: double.infinity, height: 16),
                      _buildPlaceholderLine(width: 250, height: 16),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildPlaceholderChip(width: 100),
                          _buildPlaceholderChip(width: 150),
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
                _buildPlaceholderLine(width: 80, height: 20),
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

            // Included Tests Placeholder (3 items)
            _buildPlaceholderLine(width: 220),
            const SizedBox(height: 12),
            _buildTestItemPlaceholder(),
            _buildTestItemPlaceholder(),
            _buildTestItemPlaceholder(),
            const SizedBox(height: 30),

            // Provider Info Placeholder
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
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildPlaceholderBox({
    required double height,
    required double width,
    double borderRadius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildPlaceholderChip({required double width}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: _buildPlaceholderLine(width: width, height: 12),
    );
  }

  Widget _buildTestItemPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          _buildPlaceholderBox(height: 18, width: 18, borderRadius: 9),
          const SizedBox(width: 8),
          Expanded(child: _buildPlaceholderLine(width: double.infinity)),
          _buildPlaceholderLine(width: 60),
        ],
      ),
    );
  }
}