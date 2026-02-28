// File: lib/pages/dashboard/all_pages/all_brands_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../models/BrandM/brand_model.dart';
import '../widgets/brand_card.dart';

class AllBrandsPage extends StatelessWidget {
  final List<BrandModel> brands;
  const AllBrandsPage({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("All Brands",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: brands.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 6 : 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return BrandCard(brand: brands[index]);
        },
      ),
    );
  }
}