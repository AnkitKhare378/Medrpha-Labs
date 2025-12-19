import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/color/colors.dart';
import '../../../../../models/device_product.dart';
import 'product_card.dart'; // <-- your card widget that shows each product

// horizontal_product_list.dart
class HorizontalProductList extends StatelessWidget {
  final String category;
  final List<DeviceProduct> allProducts;
  final void Function(int)? onCartChanged;

  const HorizontalProductList({
    Key? key,
    required this.category,
    required this.allProducts,
    this.onCartChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filtered =
    allProducts.where((p) => p.category == category).toList();

    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final product = filtered[index];
          return ProductCard(
            product: product,
          );
        },
      ),
    );
  }
}


