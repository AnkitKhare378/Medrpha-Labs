import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LabShimmerLoading extends StatelessWidget {
  const LabShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(4, (index) => _buildShimmerItem()),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image/Icon Placeholder
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Placeholder
                Container(
                  height: 18,
                  width: double.infinity,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8, right: 60),
                ),
                // Text Line Placeholders
                Container(
                  height: 14,
                  width: double.infinity,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 6, right: 120),
                ),
                Container(
                  height: 14,
                  width: double.infinity,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 6, right: 80),
                ),
                Container(
                  height: 14,
                  width: double.infinity,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 6, right: 160),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}