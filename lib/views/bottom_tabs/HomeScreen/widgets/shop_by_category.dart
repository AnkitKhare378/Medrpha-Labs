import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../pages/dashboard/bloc/categtory_bloc/category_bloc.dart';
import '../../../../pages/dashboard/bloc/categtory_bloc/category_event.dart';
import '../../../../pages/dashboard/bloc/categtory_bloc/category_state.dart';
import '../../CategoryScreen/category_item.dart';

class ShopByCategory extends StatefulWidget {
  const ShopByCategory({super.key});

  @override
  State<ShopByCategory> createState() => _ShopByCategoryState();
}

class _ShopByCategoryState extends State<ShopByCategory> {
  late final CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    // ✅ Reuse existing Bloc if available, otherwise create
    _categoryBloc = context.read<CategoryBloc>();
    if (_categoryBloc.state is! CategoryLoaded) {
      _categoryBloc.add(FetchCategories());
    }
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

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shop by Category",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.72,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 60, height: 8, color: Colors.white),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(List categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shop by Category",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.72,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final item = categories[index];
              return buildCategoryItem(
                CategoryItem(
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
}
