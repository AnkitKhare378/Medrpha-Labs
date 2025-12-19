import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget _buildShimmerPlaceholder({
  required double width,
  required double height,
  required BuildContext context,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white, // The base color of the shimmer area
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

class WalletShimmer extends StatelessWidget {
  const WalletShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // The card background (base color)
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300, // Color of the static part
        highlightColor: Colors.grey.shade100, // Color of the moving highlight
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Wallet Total Title Placeholder
            _buildShimmerPlaceholder(
                width: 100, height: 15, context: context),
            const SizedBox(height: 4),

            // 2. Formatted Balance Placeholder
            _buildShimmerPlaceholder(
                width: 180, height: 28, context: context),
            const Divider(height: 28, color: Colors.transparent), // Use transparent divider as a spacer

            // 3. First Wallet Row Placeholder (Medr Cash)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerPlaceholder(
                    width: 100, height: 18, context: context), // Label
                _buildShimmerPlaceholder(
                    width: 80, height: 18, context: context), // Value
              ],
            ),
            const SizedBox(height: 12),

            // 4. Second Wallet Row Placeholder (Medr Supercash)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerPlaceholder(
                    width: 120, height: 18, context: context), // Label
                _buildShimmerPlaceholder(
                    width: 60, height: 18, context: context), // Value
              ],
            ),
          ],
        ),
      ),
    );
  }
}
