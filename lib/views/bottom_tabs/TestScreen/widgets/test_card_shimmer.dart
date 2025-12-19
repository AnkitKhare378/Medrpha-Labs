import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TestShimmer extends StatelessWidget {
  const TestShimmer ({super.key});

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 0),
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
            Container(
              width: 70,
              height: 70,
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
                  SizedBox(height: 10,),
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
      ),
    );
  }
}