import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AddressEditShimmer extends StatelessWidget {
  const AddressEditShimmer({super.key});

  Widget _buildShimmerBox(double height, [double width = double.infinity]) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title Field
          _buildShimmerBox(16, 80),
          const SizedBox(height: 8),
          _buildShimmerBox(50),
          const SizedBox(height: 16),

          // Flat/House Number Field
          _buildShimmerBox(16, 120),
          const SizedBox(height: 8),
          _buildShimmerBox(50),
          const SizedBox(height: 16),

          // Street Field
          _buildShimmerBox(16, 100),
          const SizedBox(height: 8),
          _buildShimmerBox(50),
          const SizedBox(height: 16),

          // Locality Field
          _buildShimmerBox(16, 150),
          const SizedBox(height: 8),
          _buildShimmerBox(50),
          const SizedBox(height: 16),

          // Pincode Field
          _buildShimmerBox(16, 80),
          const SizedBox(height: 8),
          _buildShimmerBox(50, 150),
          const SizedBox(height: 20),

          // Address Type Selection Header
          _buildShimmerBox(18, 180),
          const SizedBox(height: 10),

          // Address Type Buttons
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildShimmerBox(30, 80),
              _buildShimmerBox(30, 80),
              _buildShimmerBox(30, 80),
            ],
          ),
          const SizedBox(height: 30),

          // Save/Update Button
          _buildShimmerBox(50),
        ],
      ),
    );
  }
}