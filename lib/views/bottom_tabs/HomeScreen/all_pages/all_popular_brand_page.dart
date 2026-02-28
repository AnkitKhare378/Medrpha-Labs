import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/color/colors.dart';
import '../../CategoryScreen/popular_products.dart';

class AllPopularBrandsPage extends StatelessWidget {
  final List brands;
  const AllPopularBrandsPage({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    // Determine responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isLargeTablet = screenWidth > 900;

    // Adjust columns based on screen width
    int crossAxisCount = 4; // Default for Mobile
    if (isLargeTablet) {
      crossAxisCount = 8;
    } else if (isTablet) {
      crossAxisCount = 6;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Popular Brands",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textColor,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: false,
      ),
      body: brands.isEmpty
          ? const Center(child: Text("No brands available."))
          : LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            itemCount: brands.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 20,
              // 🔥 FIXED: Lowered ratios to give more vertical space.
              // Lower ratio = Taller box. 0.65 provides safety for wrapping text.
              childAspectRatio: isTablet ? 0.8 : 0.65,
            ),
            itemBuilder: (context, index) {
              // Aligning to top ensures content doesn't stretch
              // if the box is taller than the content.
              return Align(
                alignment: Alignment.topCenter,
                child: PopularProducts(brand: brands[index]),
              );
            },
          );
        },
      ),
    );
  }
}