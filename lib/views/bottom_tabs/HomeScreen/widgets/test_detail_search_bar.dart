// test_detail_search_bar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/config/color/colors.dart';

class TestDetailSearchBar extends StatelessWidget {
  const TestDetailSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search for",
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            hintStyle: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      ),
    );
  }
}