import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/views/bottom_tabs/CategoryScreen/popular_products.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/pages/save_for_later_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/TestM/test_search_model.dart';
import '../../../pages/dashboard/bloc/categtory_bloc/category_bloc.dart';
import '../../../pages/dashboard/bloc/categtory_bloc/category_event.dart';
import '../../../pages/dashboard/bloc/categtory_bloc/category_state.dart';
import '../../../view_model/TestVM/AllTestSearch/all_test_serach_model.dart';
import '../../Dashboard/widgets/slide_page_route.dart';
import '../HomeScreen/pages/package_detail_page.dart';
import '../HomeScreen/widgets/custom_search_bar.dart';
import '../HomeScreen/widgets/shop_by_category.dart';
import '../TestScreen/lab_test_detail_page.dart';
import '../TestScreen/lab_test_list_page.dart';
import 'category_item.dart';
import 'sections/popular_brands_section.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int selectedCategoryIndex = 0;
  bool _isSearching = false;
  final TextEditingController myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(FetchCategories());
    });
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<TestSearchBloc>().add(ClearSearch());
    } else {
      context.read<TestSearchBloc>().add(SearchQueryChanged(query));
    }
  }

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
                    _buildHeaderButton(
                        _isSearching ? Icons.close : Iconsax.search_normal_1,
                            () {
                          setState(() {
                            _isSearching = !_isSearching;
                            if (!_isSearching) myController.clear();
                          });
                        }
                    ),
                    const SizedBox(width: 12),
                    _buildHeaderButton(Iconsax.bookmark, () {
                      Navigator.of(context).push(SlidePageRoute(page: SaveForLaterPage()));
                    }),
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
                  if (_isSearching)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: CustomSearchBar(
                          controller: myController,
                          onChanged: _onSearchChanged
                      ),
                    ),

                  BlocBuilder<TestSearchBloc, TestSearchState>(
                    builder: (context, state) {
                      if (state is SearchLoading) return const LinearProgressIndicator();
                      if (state is SearchSuccess && state.results.isNotEmpty) {
                        return Column(
                          children: state.results.map((test) => _buildTestResultTile(context, test)).toList(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: _buildOfferBanner(),
                  // ),

                  const SizedBox(height: 10),

                  const PopularBrandsSection(),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'New on Medrpha',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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

                  ShopByCategory(isCategory: true,),

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

  Widget _buildTestResultTile(BuildContext context, TestSearchModel test) {
    return ListTile(
      leading: const Icon(Icons.medical_services_outlined, color: AppColors.primaryColor),
      title: Text(test.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
      onTap: () {
        // 1. Clear the Bloc state so results disappear
        context.read<TestSearchBloc>().add(ClearSearch());

        // 2. Clear the Text field UI
        myController.clear();
        if (test.groupType == 2) {
          Navigator.of(context).push(SlidePageRoute(page: LabTestDetailPage(testId: test.id)));
        } else if (test.groupType == 1) {
          Navigator.of(context).push(SlidePageRoute(page: LabTestListPage(labName: test.name, labId: test.id)));
        } else {
          Navigator.of(context).push(SlidePageRoute(page: PackageDetailPage(packageId: test.id)));
        }
      },
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
