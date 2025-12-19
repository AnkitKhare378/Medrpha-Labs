import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/grid_button.dart';

import 'widgets/filter_app_bar.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int selectedIndex = 0;
  String selectedSort = "Popularity";

  final List<String> filterCategories = [
    "Sort by (1)",
    "Price Range",
    "Lab Accreditation",
    "Turnaround Time",
    "Lab Ratings",
    "Popular Chains",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FilterAppBar(title: "Filters (1)"),
      body: Row(
        children: [
          // Left Menu
          Container(
            width: 120,
            color: Colors.grey.shade200,
            child: ListView.builder(
              itemCount: filterCategories.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    color: isSelected ? Colors.white : Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
                    child: Text(
                      filterCategories[index],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: _buildRightContent(),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: GridButton(
                text: "CLEAR FILTERS",
                backgroundColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.grey,
                onPressed: () {
                  setState(() {
                    selectedSort = "Popularity";
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GridButton(text: 'APPLY FILTER', backgroundColor: Colors.blueAccent, textColor: Colors.white,
                  onPressed: (){}, borderColor: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightContent() {
    if (selectedIndex == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sort by", style: GoogleFonts.poppins(fontSize: 14)),
          const SizedBox(height: 10),
          _buildRadio("Popularity"),
          _buildRadio("High to Low"),
          _buildRadio("Low to High"),
        ],
      );
    }
    return Center(
      child: Text(
        "Options for ${filterCategories[selectedIndex]}",
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  Widget _buildRadio(String value) {
    return RadioListTile<String>(
      title: Text(value, style: GoogleFonts.poppins(fontSize: 13)),
      value: value,
      groupValue: selectedSort,
      onChanged: (val) {
        setState(() {
          selectedSort = val!;
        });
      },
    );
  }
}
