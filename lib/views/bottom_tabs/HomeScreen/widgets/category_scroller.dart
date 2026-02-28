import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/all_lab_medicine_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/all_test_list_page.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../all_pages/all_categories_page.dart';
import '../pages/all_lab_page.dart';

class CategoryScroller extends StatelessWidget {
  const CategoryScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'label': 'Medicine', 'color': Colors.blue.shade50, 'image': 'assets/images/medicine.png'},
      {'label': 'Labs', 'color': Colors.green.shade50, 'image': 'assets/images/lab.png'},
      {'label': 'Lab Tests', 'color': Colors.brown.shade50, 'image': 'assets/images/test.png'},
      {'label': 'Lab Packages', 'color': Colors.brown.shade50, 'image': 'assets/images/packages.png'},
      // {'label': 'Wellness', 'color': Colors.orange.shade50, 'image': 'assets/images/wellness.png'},
      // {'label': 'Fitness', 'color': Colors.purple.shade50, 'image': 'assets/images/fitness.png'},
      // {'label': 'Beauty', 'color': Colors.pink.shade50, 'image': 'assets/images/beauty.png'},
      // {'label': 'Diabetes', 'color': Colors.red.shade50, 'image': 'assets/images/medicine.png'},
      // {'label': 'Blogs', 'color': Colors.teal.shade50, 'image': 'assets/images/medicine.png'},
      // {'label': 'Selfcare', 'color': Colors.yellow.shade50, 'image': 'assets/images/medicine.png'},
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        // IMPORTANT: itemCount must be length + 1 to show the View All button
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          // If we are at the last index, show the "View All" button
          if (index == categories.length) {
            return _buildViewAllButton(context, categories);
          }

          final category = categories[index];
          return GestureDetector(
            onTap: () => _handleNavigation(context, category),
            child: Container(
              width: 90,
              decoration: BoxDecoration(
                color: category['color'],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(category['image'], height: 50),
                  const SizedBox(height: 8),
                  Text(
                    category['label'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method for the "View All" button
  Widget _buildViewAllButton(BuildContext context, List<Map<String, dynamic>> categories) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          SlidePageRoute(page: AllCategoriesPage(categories: categories)),
        );
      },
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.grid_view_rounded, color: Colors.blueAccent, size: 30),
            const SizedBox(height: 8),
            Text(
              "View All",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Centralized navigation logic
  void _handleNavigation(BuildContext context, Map<String, dynamic> category) {
    if (category['label'] == 'Labs') {
      Navigator.of(context).push(
        SlidePageRoute(page: AllLabsPage(labName: category['label'])),
      );
    }
    else if (category['label'] == 'Lab Tests') {
      Navigator.of(context).push(
        SlidePageRoute(page: AllTestListPage()),
      );
    } else if (category['label'] == 'Lab Packages') {
      Navigator.of(context).push(
        SlidePageRoute(page: AllLabsPage(labName: category['label'], isPackage: true,)),
      );
    }
    else {
      Navigator.of(context).push(
        SlidePageRoute(
          page: AllLabMedicinePage(labName: "Select lab to choose medicine"),
        ),
      );
    }
  }
}