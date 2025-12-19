import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/all_lab_medicine_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/all_test_list_page.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CategoryScreen/devices/device_page.dart';
import '../pages/all_lab_page.dart';
import '../pages/search_detail_page.dart'; // DevicePage

class CategoryScroller extends StatelessWidget {
  const CategoryScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'label': 'Medicine',
        'color': Colors.blue.shade50,
        'image': 'assets/images/medicine.png',
      },
      {
        'label': 'Labs',
        'color': Colors.green.shade50,
        'image': 'assets/images/lab.png',
      },
      {
        'label': 'Lab Tests',
        'color': Colors.brown.shade50,
        'image': 'assets/images/test.png',
      },
      {
        'label': 'Wellness',
        'color': Colors.orange.shade50,
        'image': 'assets/images/wellness.png',
      },
      {
        'label': 'Fitness',
        'color': Colors.purple.shade50,
        'image': 'assets/images/fitness.png',
      },
      {
        'label': 'Beauty',
        'color': Colors.pink.shade50,
        'image': 'assets/images/beauty.png',
      },
      {
        'label': 'Diabetes',
        'color': Colors.red.shade50,
        'image': 'assets/images/medicine.png',
      },
      {
        'label': 'Blogs',
        'color': Colors.teal.shade50,
        'image': 'assets/images/medicine.png',
      },
      {
        'label': 'Selfcare',
        'color': Colors.yellow.shade50,
        'image': 'assets/images/medicine.png',
      },
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              if (category['label'] == 'Labs') {
                Navigator.of(context).push(
                  SlidePageRoute(
                    page: AllLabsPage(
                      labName: category['label'], // pass label
                    ),
                  ),
                );
              }
              else if(category['label'] == 'Lab Tests'){
                Navigator.of(context).push(
                  SlidePageRoute(
                    page: AllTestListPage()
                  ),
                );
              }
              else {
                Navigator.of(context).push(
                  SlidePageRoute(
                    page: AllLabMedicinePage(labName: "Select lab to choose medicine")
                  ),
                );
              }
            },
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
                  Image.asset(category['image'], height: 50,),
                  const SizedBox(height: 8),
                  Text(
                    category['label'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
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
