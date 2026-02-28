import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../CategoryScreen/category_item.dart'; // Ensure this path is correct

class AllShopCategoriesPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  const AllShopCategoriesPage({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    // Determine responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isLargeTablet = screenWidth > 900;

    // Adjust columns based on device
    int crossAxisCount = 4; // Mobile default
    if (isLargeTablet) {
      crossAxisCount = 8;
    } else if (isTablet) {
      crossAxisCount = 6;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "All Categories",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: false,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8,
          mainAxisSpacing: 20,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final item = categories[index];

          // We wrap your existing buildCategoryItem to fit the grid
          return buildCategoryItem(
            CategoryItem(
              item['id'],
              item['label'],
              item['image'],
              item['color'] ?? Colors.blue.shade50,
            ),
            context,
          );
        },
      ),
    );
  }
}