import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../models/product_item.dart';
import '../widgets/product_card.dart';

class FeaturedProductsSection extends StatefulWidget {
  final List<ProductItem> products;
  const FeaturedProductsSection({Key? key, required this.products})
      : super(key: key);

  @override
  State<FeaturedProductsSection> createState() =>
      _FeaturedProductsSectionState();
}

class _FeaturedProductsSectionState extends State<FeaturedProductsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Featured products',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 320,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: widget.products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final p = widget.products[index];
              return ProductCard(
                product: p,
                onBookmarkToggle: () =>
                    setState(() => p.isSaved = !p.isSaved),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
