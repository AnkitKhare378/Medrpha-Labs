import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mimics the outer container of ProfileHeader
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Use a light shadow to maintain UI context
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            // Avatar Placeholder
            Container(
              width: 65,
              height: 65,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 18),
            // Info Placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Placeholder
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  // Phone Placeholder
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  // Completion Text Placeholder
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  // Progress Bar Placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 8,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Edit Button Placeholder
            Container(
              width: 50,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}