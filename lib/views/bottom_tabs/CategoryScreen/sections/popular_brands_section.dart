import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/color/colors.dart';
import '../../../../data/repositories/brand_service/brand_service.dart';
import '../../../../view_model/BrandVM/brand_cubit.dart';
import '../../../../view_model/BrandVM/brand_state.dart';
import '../../../Dashboard/widgets/slide_page_route.dart'; // Ensure correct path
import '../../HomeScreen/all_pages/all_popular_brand_page.dart';
import '../popular_products.dart';

class PopularBrandsSection extends StatelessWidget {
  const PopularBrandsSection({super.key});

  // Helper for navigation
  void _navigateToAll(BuildContext context, List brands) {
    Navigator.of(context).push(
      SlidePageRoute(page: AllPopularBrandsPage(brands: brands)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return BlocProvider<BrandCubit>(
      create: (context) => BrandCubit(BrandService())..fetchBrands(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Section Title with View All Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Brands',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                BlocBuilder<BrandCubit, BrandState>(
                  builder: (context, state) {
                    if (state is BrandLoaded) {
                      final popularBrands = state.brands.where((b) => b.isPop).toList();
                      return GestureDetector(
                        onTap: () => _navigateToAll(context, popularBrands),
                        child: Text(
                          "View All",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Popular Brands LIST
          SizedBox(
            height: 120, // Increased slightly to prevent overflow
            child: BlocBuilder<BrandCubit, BrandState>(
              builder: (context, state) {
                if (state is BrandLoading) {
                  return _buildBrandLoadingList();
                } else if (state is BrandLoaded) {
                  final popularBrands = state.brands.where((b) => b.isPop).toList();

                  if (popularBrands.isEmpty) {
                    return const Center(child: Text('No popular brands found.'));
                  }

                  // Logic for "More" card
                  int displayLimit = isTablet ? 8 : 5;
                  bool hasMore = popularBrands.length > displayLimit;
                  int itemCount = hasMore ? displayLimit + 1 : popularBrands.length;

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: itemCount,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      if (hasMore && index == displayLimit) {
                        return _buildMoreCard(context, popularBrands);
                      }
                      return PopularProducts(brand: popularBrands[index]);
                    },
                  );
                } else if (state is BrandError) {
                  return Center(
                    child: Text(
                      'Failed to load brands.',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Circular "More" card at the end of the scroller
  Widget _buildMoreCard(BuildContext context, List brands) {
    return GestureDetector(
      onTap: () => _navigateToAll(context, brands),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.blueAccent),
          ),
          const SizedBox(height: 8),
          Text(
            "More",
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

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
}