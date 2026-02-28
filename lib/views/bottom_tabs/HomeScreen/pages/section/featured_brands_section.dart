// File: lib/pages/dashboard/widgets/featured_brands_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/view_model/BrandVM/brand_cubit.dart';
import 'package:medrpha_labs/view_model/BrandVM/brand_state.dart';
import '../../../../Dashboard/widgets/slide_page_route.dart';
import '../../../../../data/repositories/brand_service/brand_service.dart';
import '../../../../../models/BrandM/brand_model.dart';
import '../../all_pages/all_brands_page.dart';
import '../../widgets/brand_card.dart';
// Import the new page we will create below

class FeaturedBrandsSection extends StatelessWidget {
  const FeaturedBrandsSection({super.key});

  void _navigateToAllBrands(BuildContext context, List<BrandModel> brands) {
    Navigator.of(context).push(
      SlidePageRoute(page: AllBrandsPage(brands: brands)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrandCubit(BrandService())..fetchBrands(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Brands',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                // Header "View All" Button
                BlocBuilder<BrandCubit, BrandState>(
                  builder: (context, state) {
                    if (state is BrandLoaded && state.brands.length > 5) {
                      return GestureDetector(
                        onTap: () => _navigateToAllBrands(context, state.brands),
                        child: Text(
                          "View All",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
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
          const SizedBox(height: 15),
          SizedBox(
            height: 110,
            child: BlocBuilder<BrandCubit, BrandState>(
              builder: (context, state) {
                if (state is BrandLoading) {
                  return _buildLoadingList();
                } else if (state is BrandLoaded) {
                  return _buildBrandList(context, state.brands);
                } else if (state is BrandError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandList(BuildContext context, List<BrandModel> brands) {
    if (brands.isEmpty) {
      return const Center(child: Text('No brands found.'));
    }

    // Limit to 8 brands on the home screen, then show "More"
    final int displayLimit = brands.length > 8 ? 8 : brands.length;
    final bool hasMore = brands.length > 8;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: hasMore ? displayLimit + 1 : displayLimit,
      itemBuilder: (context, index) {
        if (hasMore && index == displayLimit) {
          return _buildViewAllCircle(context, brands);
        }
        return Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: BrandCard(brand: brands[index]),
        );
      },
    );
  }

  // Circular "More" button at the end of scroller
  Widget _buildViewAllCircle(BuildContext context, List<BrandModel> brands) {
    return GestureDetector(
      onTap: () => _navigateToAllBrands(context, brands),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            ),
            child: const Icon(Icons.arrow_forward_rounded, color: Colors.blueAccent),
          ),
          const SizedBox(height: 8),
          Text(
            "More",
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500),
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
      itemBuilder: (context, index) =>Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: BrandPlaceholder(),
      ),
    );
  }
}

class BrandPlaceholder extends StatelessWidget {
  // Add 'const' here
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
            shape: BoxShape.circle, // Updated to match the circular brand UI
          ),
        ),
        const SizedBox(height: 8),
        Container(
            width: 50,
            height: 10,
            color: Colors.grey.shade300
        ),
      ],
    );
  }
}