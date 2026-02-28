import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../pages/dashboard/bloc/categtory_bloc/category_bloc.dart';
import '../../../../pages/dashboard/bloc/categtory_bloc/category_event.dart';
import '../../../../pages/dashboard/bloc/categtory_bloc/category_state.dart';
import '../../CategoryScreen/category_item.dart';
import '../../../Dashboard/widgets/slide_page_route.dart'; // Ensure correct path
import '../all_pages/all_categories_page.dart';
import '../all_pages/all_shop_category_page.dart'; // Ensure correct path

class ShopByCategory extends StatefulWidget {
  final bool? isCategory;
  const ShopByCategory({super.key, this.isCategory});

  @override
  State<ShopByCategory> createState() => _ShopByCategoryState();
}

class _ShopByCategoryState extends State<ShopByCategory> {
  late final CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    print(widget.isCategory);
    _categoryBloc = context.read<CategoryBloc>();
    if (_categoryBloc.state is! CategoryLoaded) {
      _categoryBloc.add(FetchCategories());
    }
  }

  // Helper to navigate to View All page
  void _navigateToAll(List categories) {
    Navigator.of(context).push(
      SlidePageRoute(
        page: AllShopCategoriesPage( // Updated to the new class name
          categories: categories.map((e) => {
            'label': e.name,
            'image': e.image,
            'id': e.id,
            'color': Colors.blue.shade50,
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return _buildShimmer();
        } else if (state is CategoryLoaded) {
          return _buildCategoryGrid(state.categories);
        } else if (state is CategoryError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  // ================= CATEGORY GRID =================

  Widget _buildCategoryGrid(List categories) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    // Define limits: 8 items for mobile (2 rows of 4), 12 for tablet (2 rows of 6)
    final int maxItems = isTablet ? 12 : 8;
    final bool hasMore = categories.length > maxItems;
    final int displayCount = hasMore ? maxItems : categories.length;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 8 : 16,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shop by Category",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // if (hasMore)
                GestureDetector(
                  onTap: () => _navigateToAll(categories),
                  child: Text(
                    "View All",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          if(widget.isCategory == false) ...[
            const SizedBox(height: 18),
          ],

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 6 : 4,
              crossAxisSpacing: 0,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              // If we reach the last slot and there are more items, show "View All" tile
              if (hasMore && index == maxItems - 1) {
                return _buildViewAllTile(isTablet, categories);
              }

              final item = categories[index];
              return buildCategoryItem(
                CategoryItem(
                  item.id,
                  item.name,
                  item.image,
                  Colors.blue.shade100,
                ),
                context,
              );
            },
          ),
        ],
      ),
    );
  }

  // The custom "View All" tile inside the grid
  Widget _buildViewAllTile(bool isTablet, List categories) {
    return InkWell(
      onTap: () => _navigateToAll(categories),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isTablet ? 85 : 70,
            height: isTablet ? 85 : 70,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.blueAccent, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            "More",
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ================= SHIMMER (Updated to match grid) =================

  Widget _buildShimmer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 150, height: 20, color: Colors.white),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: isTablet ? 12 : 8,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 6 : 4,
              crossAxisSpacing: 0,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: isTablet ? 85 : 70,
                      height: isTablet ? 85 : 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 50, height: 8, color: Colors.white),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}