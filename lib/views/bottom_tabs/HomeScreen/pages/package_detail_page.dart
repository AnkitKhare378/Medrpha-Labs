import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/config/color/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/routes_name.dart';
import '../../../../data/repositories/package_service/package_detail_service.dart';
import '../../../../models/TestM/test_search_model.dart';
import '../../../../view_model/PackageVM/package_detail_view_model.dart';
import '../../../../view_model/TestVM/AllTestSearch/all_test_serach_model.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../TestScreen/lab_test_detail_page.dart';
import '../../TestScreen/lab_test_list_page.dart';
import '../widgets/package_detail_shimmer.dart';
import '../widgets/package_detail_widgets.dart';

class PackageDetailPage extends StatefulWidget {
  final int packageId;
  const PackageDetailPage({super.key, required this.packageId});

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  final TextEditingController searchController = TextEditingController();

  void _onSearchChanged(String query) {
    // Adding setState to update the Clear button visibility in the search bar
    setState(() {});
    if (query.isEmpty) {
      context.read<TestSearchBloc>().add(ClearSearch());
    } else {
      context.read<TestSearchBloc>().add(SearchQueryChanged(query));
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;

    return BlocProvider(
      create: (context) => PackageDetailBloc(PackageDetailService())
        ..add(FetchPackageDetail(widget.packageId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.read<TestSearchBloc>().add(ClearSearch());
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Package Details",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Functional Search Bar
              PackageDetailSearchBar(
                controller: searchController,
                onChanged: _onSearchChanged,
              ),

              // Search Results Overlay Logic
              BlocBuilder<TestSearchBloc, TestSearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      color: AppColors.primaryColor,
                    );
                  }
                  if (state is SearchSuccess && state.results.isNotEmpty) {
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: state.results
                            .map((test) => _buildTestResultTile(context, test))
                            .toList(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Main Package Detail Content with Shimmer
              BlocBuilder<PackageDetailBloc, PackageDetailState>(
                builder: (context, state) {
                  if (state is PackageDetailLoading) {
                    // This returns your custom shimmer widget
                    return const PackageDetailShimmer();
                  }

                  if (state is PackageDetailError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                      child: Center(
                        child: Text(
                          "Failed to load details: ${state.message}",
                          style: GoogleFonts.poppins(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (state is PackageDetailLoaded) {
                    final detail = state.packageDetail;

                    if (detail.packageTests.isEmpty) {
                      return _buildEmptyState();
                    }

                    return PackageDetailLoadedContent(detail: detail);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: cartCount > 0 ? _buildCartBottomBar(context, cartCount) : null,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Image.network(
              "https://cdn-icons-png.flaticon.com/128/17134/17134613.png",
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              "Currently no tests are in package.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartBottomBar(BuildContext context, int cartCount) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$cartCount item${cartCount > 1 ? 's' : ''} in cart',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, RoutesName.cartScreen),
              child: Text(
                'Go to Cart',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
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
        context.read<TestSearchBloc>().add(ClearSearch());
        searchController.clear();
        FocusScope.of(context).unfocus();

        if (test.groupType == 2) {
          Navigator.of(context).push(SlidePageRoute(page: LabTestDetailPage(testId: test.id)));
        } else if (test.groupType == 1) {
          Navigator.of(context).push(SlidePageRoute(page: LabTestListPage(labName: test.name, labId: test.id)));
        } else {
          if (test.id != widget.packageId) {
            Navigator.of(context).push(SlidePageRoute(page: PackageDetailPage(packageId: test.id)));
          }
        }
      },
    );
  }
}