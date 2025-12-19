import 'package:flutter/material.dart';
import '../../../../../models/device_product.dart';
import 'category_card.dart';

class CategoryGrid extends StatelessWidget {
  final List<DeviceProduct> allProducts;
  final ValueChanged<int>? onCartChanged;

  const CategoryGrid({
    Key? key,
    required this.allProducts,
    this.onCartChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryProducts =
    allProducts.where((p) => p.category == 'category').toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.70, // ⬇ shorter ratio → taller cards
        ),
        itemCount: categoryProducts.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            product: categoryProducts[index],
            onCartChanged: onCartChanged,
          );
        },
      ),
    );
  }
}
