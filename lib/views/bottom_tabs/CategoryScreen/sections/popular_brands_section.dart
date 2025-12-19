import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/color/colors.dart';
import '../../../../data/repositories/brand_service/brand_service.dart';
import '../../../../view_model/BrandVM/brand_cubit.dart';
import '../../../../view_model/BrandVM/brand_state.dart';
import '../popular_products.dart';


class PopularBrandsSection extends StatelessWidget {
  const PopularBrandsSection({super.key});

  // Helper widget for brand loading shimmer
  Widget _buildBrandLoadingList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(width: 60, height: 8, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 💡 Provide the BrandCubit here, which triggers the fetchBrands() on creation
    return BlocProvider<BrandCubit>(
      create: (context) => BrandCubit(BrandService())..fetchBrands(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Brands Section Title
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Popular Brands',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Popular Brands LIST
          SizedBox(
            height: 110,
            child: BlocBuilder<BrandCubit, BrandState>(
              builder: (context, state) {
                if (state is BrandLoading) {
                  return _buildBrandLoadingList();
                } else if (state is BrandLoaded) {
                  // Filter brands where isPop is true
                  final popularBrands = state.brands.where((b) => b.isPop).toList();

                  if (popularBrands.isEmpty) {
                    return const Center(child: Text('No popular brands found.'));
                  }

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: popularBrands.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      // 💡 Pass the fetched BrandModel to PopularProducts
                      return PopularProducts(brand: popularBrands[index]);
                    },
                  );
                } else if (state is BrandError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Failed to load brands. Tap to retry.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}