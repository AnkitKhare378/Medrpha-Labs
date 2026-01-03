import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/views/bottom_tabs/CategoryScreen/popular_products.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../pages/dashboard/bloc/categtory_bloc/category_bloc.dart';
import '../../../pages/dashboard/bloc/categtory_bloc/category_event.dart';
import '../../../pages/dashboard/bloc/categtory_bloc/category_state.dart';
import 'category_item.dart';
import 'sections/popular_brands_section.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    // 🚀 Dispatch the event to load categories when the page initializes
    // This ensures the API call starts immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(FetchCategories());
    });
  }


  final List<CategoryItem> categoryItems = [
    CategoryItem(
      1,
      'Medicines',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1711135829698.png',
      Colors.pink.shade100,
    ),
    CategoryItem(
      2,
      'Devices',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1711135873220.png',
      Colors.purple.shade100,
    ),
    CategoryItem(
      3,
      'Personal Care',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1712129336907.png',
      Colors.orange.shade100,
    ),
    CategoryItem(
      4,
      'Surgicals',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1712129450727.png',
      Colors.blue.shade100,
    ),
    CategoryItem(
      5,
      'Wellness',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1711135480816.png',
      Colors.red.shade100,
    ),
    CategoryItem(
      6,
      'Fitness',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1711135324627.png',
      Colors.brown.shade100,
    ),
    CategoryItem(
      7,
      'Petcare',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1712043199167.png',
      Colors.grey.shade100,
    ),
    CategoryItem(
      8,
      'Eyewear',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1712129539687.png',
      Colors.green.shade100,
    ),
    CategoryItem(
      9,
      'Women Care',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1712129579415.png',
      Colors.pink.shade100,
    ),
    CategoryItem(
      10,
      'Treatments',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1712129613695.png',
      Colors.blue.shade100,
    ),
    CategoryItem(
      11,
      'Ayush',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1711135920391.png',
      Colors.orange.shade100,
    ),
    CategoryItem(
      12,
      'Mom & Baby',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/original/theme-image-1716811610519.png',
      Colors.purple.shade100,
    ),
  ];

  final List<OfferCard> newOnNetmedsOffers = [
    OfferCard(
      title: 'Ayur-wellness\nUp to 60% off',
      imageUrl:
          'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:250/theme-image-1711121714540.png?dpr=3',
      gradient: [Color(0xFFE8F5E8), Color(0xFF81C784)],
    ),
    OfferCard(
      title: 'Up to 77% off\nAmbitech Products',
      imageUrl:
          'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:250/theme-image-1711121804387.jpeg?dpr=3',
      gradient: [Color(0xFFFCE4EC), Color(0xFF26C6DA)],
    ),
    OfferCard(
      title: 'Upto 35% off\nCough & Cold',
      imageUrl:
          'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:250/theme-image-1711121786785.png?dpr=3',
      gradient: [Color(0xFFE8F5E8), Color(0xFF66BB6A)],
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // 🔹 Fixed Header
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'All categories',
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildHeaderButton(Iconsax.search_normal_1, () {}),
                    const SizedBox(width: 12),
                    _buildHeaderButton(Iconsax.bookmark, () {}),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Category Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          // 🔥 Show shimmer placeholders while loading (Horizontal Layout)
                          return SizedBox(
                            height: 110, // Set fixed height
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 8, // shimmer items
                              separatorBuilder: (context, index) => const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                return SizedBox( // Item width
                                  width: 80,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: 60,
                                          height: 8,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is CategoryLoaded) {
                          final categories = state.categories;

                          return SizedBox(
                            height: 110, // Set fixed height
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final imageUrl =
                                    "${categories[index].image.replaceAll("\\", "/")}";

                                return buildCategoryItem(
                                  CategoryItem(
                                    categories[index].id,
                                    categories[index].name,
                                    imageUrl,
                                    Colors.blue.shade100,
                                  ),
                                  context,
                                );
                              },
                            ),
                          );
                        } else if (state is CategoryError) {
                          return Center(child: Text(state.message));
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),

                  // Offer Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildOfferBanner(),
                  ),

                  const SizedBox(height: 10),

                  const PopularBrandsSection(),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'New on Medrpha',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: newOnNetmedsOffers.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return _buildNewOfferCard(newOnNetmedsOffers[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // All Categories Section
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'All Categories',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: 8, // Placeholder count
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 60,
                                      height: 8,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (state is CategoryLoaded) {
                          final categories = state.categories;

                          if (categories.isEmpty) {
                            return Center(
                              child: Text('No categories found.', style: GoogleFonts.poppins()),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: categories.length, // ⭐️ Dynamic count
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final imageUrl =
                                  "${category.image.replaceAll("\\", "/")}"; // ⭐️ Dynamic image URL

                              return buildCategoryItem( // Use the existing buildCategoryItem helper
                                CategoryItem(
                                  category.id,
                                  category.name,
                                  imageUrl,
                                  Colors.blue.shade100, // Replace with dynamic color if available
                                ),
                                context,
                              );
                            },
                          );
                        } else if (state is CategoryError) {
                          return Center(
                            child: Text(
                                'Failed to load categories: ${state.message}',
                                style: GoogleFonts.poppins(color: Colors.red)
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header button widget
  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }

  // Offer Banner Widget
  Widget _buildOfferBanner() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:500/theme-image-1750851318549.png?dpr=3',
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Category item widget
  Widget _buildCategoryItem(CategoryItem item) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: item.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 75,
                      height: 75,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: item.backgroundColor,
                    child: const Icon(
                      Iconsax.category,
                      color: AppColors.primaryColor,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 85,
            child: Text(
              item.name,
              style: GoogleFonts.poppins(
                fontSize: 8,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Brand item widget


  // New offer card widget
  Widget _buildNewOfferCard(OfferCard offer) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    offer.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
            /*const SizedBox(height: 12),
            Expanded(
              flex: 1,
              child: Text(
                offer.title.replaceAll('\\n', '\n'),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  // All category item widget
  Widget _buildAllCategoryItem(AllCategoryItem item) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              flex: 1,
              child: Text(
                item.name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class OfferCard {
  final String title;
  final String imageUrl;
  final List<Color> gradient;

  OfferCard({
    required this.title,
    required this.imageUrl,
    required this.gradient,
  });
}

class AllCategoryItem {
  final String name;
  final String imageUrl;
  final Color backgroundColor;

  AllCategoryItem(this.name, this.imageUrl, this.backgroundColor);
}
