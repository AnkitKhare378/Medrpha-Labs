import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/package_detail_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/lab_test_detail_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/lab_test_list_page.dart';
import '../../../models/TestM/test_search_model.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/section/featured_brands_section.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/custom_home_appbar.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/custom_home_boxes.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/custom_search_bar.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/health_category_scroller.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/helath_concern_scroller.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/shop_by_category.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/specialized_banner.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/trending_banner.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/why_trust_section.dart';
import '../../../config/color/colors.dart';
import '../../../config/routes/routes_name.dart';
import '../../../view_model/TestVM/AllTestSearch/all_test_serach_model.dart';
import '../../Dashboard/widgets/slide_page_route.dart';
import '../CartScreen/store/cart_notifier.dart';
import 'pages/search_detail_page.dart';
import 'widgets/adv_banner.dart';
import 'widgets/category_scroller.dart';
import 'widgets/custom_floating_buttton.dart';
import 'widgets/pescription_card_section.dart';
import 'widgets/popular_test_packages.dart';
import 'widgets/product_scroller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController myController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isFabExpanded = true;
  String _currentLocation = "Fetching...";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _getLocation();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      // When empty, dispatch ClearSearch to set state to SearchInitial
      context.read<TestSearchBloc>().add(ClearSearch());
    } else {
      // When not empty, dispatch SearchQueryChanged
      context.read<TestSearchBloc>().add(SearchQueryChanged(query));
    }
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _currentLocation = "Disabled");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _currentLocation = "Permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _currentLocation = "Permission permanently denied");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      setState(() {
        _currentLocation = placemarks.first.locality ?? "Unknown";
      });
    }
  }

  void _handleScroll() {
    final isScrollingDown = _scrollController.position.userScrollDirection == ScrollDirection.reverse;
    final isScrollingUp = _scrollController.position.userScrollDirection == ScrollDirection.forward;

    if (isScrollingDown && _isFabExpanded) {
      setState(() {
        _isFabExpanded = false;
      });
    } else if (isScrollingUp && !_isFabExpanded) {
      setState(() {
        _isFabExpanded = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    myController.dispose();
    super.dispose();
  }

  Widget _buildTestResultTile(BuildContext context, TestSearchModel test) {
    return ListTile(
      leading: const Icon(Icons.medical_services_outlined, color: AppColors.primaryColor),
      title: Text(
        test.name,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        test.groupType == 2 ? 'Test' : 'Package',
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
      ),
      onTap: () {
        // Navigator.of(context).push(
        //   SlidePageRoute(page: LabsPage(labName: test.name)),
        // );
        if(test.groupType == 2){
          Navigator.of(context).push(
            SlidePageRoute(page: LabTestDetailPage(testId: test.id)),
          );
        }
        else if (test.groupType == 1){
          Navigator.of(context).push(
            SlidePageRoute(page: LabTestListPage(labName: test.name, labId: test.id,)),
          );
        }
        else{
          Navigator.of(context).push(
            SlidePageRoute(page: PackageDetailPage(packageId: test.id)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomHomeAppBar(
        location: _currentLocation,
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        children: [
          CustomSearchBar(
            controller: myController,
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 10),
          BlocBuilder<TestSearchBloc, TestSearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: LinearProgressIndicator(),
                ));
              }
              if (state is SearchError && myController.text.isNotEmpty) {
                return Center(child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No Result Found...",
                    style: GoogleFonts.poppins(),
                  ),
                ));
              }
              if (state is SearchSuccess && state.results.isNotEmpty) {
                return Column(
                  children: state.results.map((test) => _buildTestResultTile(context, test)).toList(),
                );
              }
              if (state is SearchSuccess && state.results.isEmpty && myController.text.isNotEmpty) {
                return Center(child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No tests or packages found for "${myController.text}"',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ));
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 20),
          CategoryScroller(),
          const SizedBox(height: 20),
          const CustomHomeBoxes(),
          const SizedBox(height: 20),
          AdvBanner(),
          const SizedBox(height: 20),
          const PrescriptionCardsSection(),
          const SizedBox(height: 20),
          SpecializedBanner(),
          const SizedBox(height: 20),
          ShopByCategory(),
          const SizedBox(height: 20),
          ProductScroller(),
          const SizedBox(height: 20),
          const FeaturedBrandsSection(),
          const SizedBox(height: 20),
          TrendingBanner(),
          const SizedBox(height: 20),
          HealthCategoryScroller(),
          const SizedBox(height: 20),
          HealthConcernScroller(),
          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/img_5.png',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          PopularTestPackages(),
          const SizedBox(height: 20),
          const WhyTrustMedrPha(),
        ],
      ),

      floatingActionButton: CustomFloatingButton(
        onPressed: () {
          debugPrint('Calling...');
        },
        isExpanded: _isFabExpanded,
      ),
      bottomNavigationBar: cartCount > 0
          ? Container(
        margin: const EdgeInsets.all(16),
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                onPressed: () =>
                    Navigator.pushNamed(context, RoutesName.cartScreen),
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
      )
          : null,
    );
  }
}