// File: lib/pages/dashboard/widgets/featured_brands_section.dart (Updated)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/view_model/BrandVM/brand_cubit.dart';
import 'package:medrpha_labs/view_model/BrandVM/brand_state.dart';

import '../../../../../data/repositories/brand_service/brand_service.dart';
import '../../../../../models/BrandM/brand_model.dart';
import '../../widgets/brand_card.dart'; // Assuming BrandCard is the circular UI
import '../../widgets/brand_logo_card.dart'; // If you're using this for placeholder, ensure it's correct

class FeaturedBrandsSection extends StatelessWidget {
  const FeaturedBrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 Provide the Cubit and call the fetch method immediately
    return BlocProvider(
      // Ensure BrandService is correctly imported/available
      create: (context) => BrandCubit(BrandService())..fetchBrands(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Featured Brands', // Keeping the original title
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Height adjusted for logo and text (~70 + 8 + 15)
          SizedBox(
            height: 110,
            child: BlocBuilder<BrandCubit, BrandState>(
              builder: (context, state) {
                if (state is BrandLoading) {
                  return _buildLoadingList();
                } else if (state is BrandLoaded) {
                  // 💡 CHANGE: Remove the filter to show all brands.
                  final allBrands = state.brands;
                  return _buildBrandList(allBrands);
                } else if (state is BrandError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox(); // Initial state (empty)
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: 4,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: BrandPlaceholder(),
      ),
    );
  }

  Widget _buildBrandList(List<BrandModel> brands) {
    if (brands.isEmpty) {
      return const Center(child: Text('No brands found.'));
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: brands.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 15.0),
          // Using BrandCard (the circular UI component)
          child: BrandCard(brand: brands[index]),
        );
      },
    );
  }
}

// Widget for the loading animation placeholder (remains unchanged)
class BrandPlaceholder extends StatelessWidget {
  const BrandPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 50, height: 10, color: Colors.grey.shade300),
      ],
    );
  }
}