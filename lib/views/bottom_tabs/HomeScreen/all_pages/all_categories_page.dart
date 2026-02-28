import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your navigation and page files here
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/all_lab_medicine_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/all_test_list_page.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../pages/all_lab_page.dart';

class AllCategoriesPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  const AllCategoriesPage({super.key, required this.categories});

  /// Navigates to the appropriate screen based on the category label
  void _handleNavigation(BuildContext context, Map<String, dynamic> category) {
    if (category['label'] == 'Labs') {
      Navigator.of(context).push(
        SlidePageRoute(page: AllLabsPage(labName: category['label'])),
      );
    } else if (category['label'] == 'Lab Tests') {
      Navigator.of(context).push(
        SlidePageRoute(page: AllTestListPage()),
      );
    } else {
      // Default navigation for Medicine and other categories
      Navigator.of(context).push(
        SlidePageRoute(
          page: AllLabMedicinePage(labName: "Select lab to choose medicine"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;

    // Breakpoints for Tablet and Mobile
    final bool isTablet = screenWidth > 600;
    final bool isLargeTablet = screenWidth > 900;

    // Adjust grid columns based on screen size
    int crossAxisCount = 3;
    if (isLargeTablet) {
      crossAxisCount = 6;
    } else if (isTablet) {
      crossAxisCount = 4;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "All Categories",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: isTablet, // Center title for a cleaner tablet look
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: isTablet ? 20 : 12,
          mainAxisSpacing: isTablet ? 20 : 12,
          childAspectRatio: isTablet ? 1.0 : 0.9,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => _handleNavigation(context, category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: category['color'],
                borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Responsive Image Asset
                  Image.asset(
                    category['image'],
                    height: isTablet ? 60 : 40,
                    width: isTablet ? 60 : 40,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      category['label'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 14 : 11,
                        color: Colors.black87,
                      ),
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
}