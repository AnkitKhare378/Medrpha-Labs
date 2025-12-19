import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FamilyMemberShimmer extends StatelessWidget {
  const FamilyMemberShimmer({super.key});

  // A widget to draw a placeholder line/box
  Widget _shimmerLine({double width = double.infinity, double height = 10.0}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // The loading card structure mimicking the actual _memberCard
  Widget _shimmerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle Avatar Placeholder
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerLine(width: 120, height: 16), // Name placeholder
                const SizedBox(height: 8),
                _shimmerLine(width: 80, height: 10),  // Age placeholder
                const SizedBox(height: 10),
                _shimmerLine(width: double.infinity, height: 6), // Progress bar placeholder
                const SizedBox(height: 4),
                _shimmerLine(width: 100, height: 10), // Completion text placeholder
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The Shimmer package handles the animated effect
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
        itemCount: 5, // Show 5 placeholder cards
        padding: const EdgeInsets.only(top: 16),
        itemBuilder: (context, index) {
          return _shimmerCard();
        },
      ),
    );
  }
}