import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PackageShimmerEffect extends StatelessWidget {
  const PackageShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isTablet = screenWidth >= 600;

    // ================= MOBILE UI =================
    if (!isTablet) {
      final double cardWidth = screenWidth * 0.43;
      final double cardHeight = screenHeight * 0.24;
      final double bookNowHeight = screenHeight * 0.05;

      return SizedBox(
        height: cardHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              width: cardWidth,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildMobileShimmer(
                cardWidth,
                bookNowHeight,
              ),
            );
          },
        ),
      );
    }

    // ================= TABLET UI =================
    final double cardWidth = screenWidth * 0.32;
    final double cardHeight = screenHeight * 0.30;
    final double bookNowHeight = screenHeight * 0.055;

    final double titleHeight = cardWidth * 0.085;
    final double subTextHeight = cardWidth * 0.07;
    final double offerHeight = cardWidth * 0.12;

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: cardWidth,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildTabletShimmer(
              titleHeight,
              subTextHeight,
              offerHeight,
              bookNowHeight,
              cardWidth,
            ),
          );
        },
      ),
    );
  }

  // ================= MOBILE SHIMMER =================
  Widget _buildMobileShimmer(
      double cardWidth,
      double bookNowHeight,
      ) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                ),
                Container(
                  height: 14,
                  width: cardWidth * 0.7,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 6),
                ),
                Container(
                  height: 12,
                  width: cardWidth * 0.5,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 15),
                ),
                Container(
                  height: 20,
                  width: cardWidth * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: bookNowHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TABLET SHIMMER =================
  Widget _buildTabletShimmer(
      double titleHeight,
      double subTextHeight,
      double offerHeight,
      double bookNowHeight,
      double cardWidth,
      ) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: titleHeight,
                  width: double.infinity,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                ),
                Container(
                  height: titleHeight,
                  width: cardWidth * 0.7,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                Container(
                  height: subTextHeight,
                  width: cardWidth * 0.5,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 14),
                ),
                Container(
                  height: offerHeight,
                  width: cardWidth * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: bookNowHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
