// lib/views/bottom_tabs/HomeScreen/widgets/test_detail_content/_star_rating_row.dart
import 'package:flutter/material.dart';

class StarRatingRow extends StatelessWidget {
  final double ratingPoint;
  final double size;

  const StarRatingRow({
    super.key,
    required this.ratingPoint,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < ratingPoint ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }
}