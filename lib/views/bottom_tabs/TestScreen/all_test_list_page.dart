import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medrpha_labs/views/bottom_tabs/CartScreen/widgets/go_to_cart_bar.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/widgets/test_card_shimmer.dart';
import 'package:medrpha_labs/views/Dashboard/pages/location_picker_screen.dart';
import '../../../config/color/colors.dart';
import '../../../data/repositories/test_service/test_service.dart';
import '../../../models/TestM/lab_test.dart';
import '../../../view_model/TestVM/AllLabTest/lab_test_cubit.dart';
import '../../../view_model/TestVM/AllLabTest/lab_test_state.dart';
import '../../Dashboard/widgets/slide_page_route.dart';
import '../CartScreen/store/cart_notifier.dart';
import 'test_list_filter_page.dart'; // Ensure this is imported
import 'widgets/lab_test_app_bar.dart';
import 'widgets/sort_filter_button.dart';
import 'widgets/test_card.dart';

class AllTestListPage extends StatefulWidget {
  const AllTestListPage({super.key});

  @override
  State<AllTestListPage> createState() => _AllTestListPageState();
}

class _AllTestListPageState extends State<AllTestListPage> {
  bool _isCheckingLocation = true;
  double? _lat;
  double? _lng;
  final double _maxDistanceInKm = 20.0;

  // ✅ Local Filter & Sort States
  String selectedSort = "Popularity";
  int selectedSymptomId = 0; // 0 means "All Symptoms"

  @override
  void initState() {
    super.initState();
    _checkLocationAndLoad();
  }

  Future<void> _checkLocationAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final double? lat = prefs.getDouble('selected_lat');
    final double? lng = prefs.getDouble('selected_lng');

    if (lat == null || lng == null) {
      _navigateToLocationPicker();
    } else {
      if (mounted) {
        setState(() {
          _lat = lat;
          _lng = lng;
          _isCheckingLocation = false;
        });
      }
    }
  }

  void _navigateToLocationPicker() async {
    final result = await Navigator.of(context).push(
      SlidePageRoute(page: const LocationPickerScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _lat = result['lat'];
        _lng = result['lng'];
        _isCheckingLocation = false;
      });
    } else if (_lat == null) {
      if (mounted) Navigator.pop(context);
    }
  }

  void _navigateToFilterPage() async {
    final Map<String, dynamic>? filterData = await Navigator.of(context).push(
      SlidePageRoute(
        page: TestFilterPage(
          initialSymptomId: selectedSymptomId,
          onApplyFilter: (id) {},
        ),
      ),
    );

    if (filterData != null) {
      setState(() {
        // ✅ We just update local state and let the build method re-filter
        selectedSymptomId = filterData["symptomId"] ?? 0;
        selectedSort = filterData["sortBy"] ?? "Popularity";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;

    if (_isCheckingLocation) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider(
      // Keep the key based on location so it refreshes only when location changes
      key: ValueKey('all_tests_${_lat}_$_lng'),
      create: (context) => AllTestCubit(TestService())..loadAllTests(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              LabTestAppBar(
                searchTexts: const ["Blood", "Diabetes", "Full Body"],
                onBack: () => Navigator.pop(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _navigateToLocationPicker,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tests within 20km",
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Tap to change location",
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        SortFilterButton(
                          label: "Sort",
                          icon: Iconsax.arrow_up_2,
                          onPressed: _navigateToFilterPage,
                        ),
                        const SizedBox(width: 10),
                        SortFilterButton(
                          label: "Filter",
                          icon: Iconsax.filter,
                          onPressed: _navigateToFilterPage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<AllTestCubit, AllTestState>(
                  builder: (context, state) {
                    if (state is AllTestLoading) {
                      return const TestShimmer();
                    } else if (state is AllTestError) {
                      return Center(child: Text(state.message));
                    } else if (state is AllTestLoaded) {

                      // 1. --- COMBINED FILTERING (Distance & Symptom) ---
                      final List<LabTest> filteredList = state.test.where((test) {
                        // A. Distance Check
                        bool isWithinDistance = false;
                        if (test.lab?.latitude != null && test.lab?.longitude != null) {
                          double dist = Geolocator.distanceBetween(
                            _lat!, _lng!,
                            double.parse(test.lab!.latitude.toString()),
                            double.parse(test.lab!.longitude.toString()),
                          );
                          isWithinDistance = (dist / 1000) <= _maxDistanceInKm;
                        }

                        // B. Symptom Check
                        // If selectedSymptomId is 0, show all. Otherwise, match ID.
                        bool matchesSymptom = (selectedSymptomId == 0) ||
                            (test.symptomId == selectedSymptomId);

                        return isWithinDistance && matchesSymptom;
                      }).toList();

                      // 2. --- MANUAL SORTING ---
                      if (selectedSort == "Low to High") {
                        filteredList.sort((a, b) => (a.testPrice).compareTo(b.testPrice));
                      } else if (selectedSort == "High to Low") {
                        filteredList.sort((a, b) => (b.testPrice).compareTo(a.testPrice));
                      }

                      if (filteredList.isEmpty) {
                        return const Center(
                          child: Text("No tests found matching your criteria."),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredList.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) => TestCard(test: filteredList[index]),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: cartCount > 0 ? GoToCartBar(cartCount: cartCount) : null,
      ),
    );
  }
}
