// lib/views/bottom_tabs/TestScreen/lab_test_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/widgets/lab_test_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconsax/iconsax.dart'; // Ensure you have this package
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import '../../../config/apiConstant/api_constant.dart'; // For image base URL

import '../../../models/LabM/symptom_model.dart';
import '../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../view_model/LabVM/AllSymptoms/symptom_bloc.dart';
import '../../../view_model/LabVM/AllSymptoms/symptom_event.dart';
import '../../../view_model/LabVM/AllSymptoms/symptom_state.dart';
import '../../Dashboard/widgets/slide_page_route.dart';
import '../HomeScreen/widgets/popular_test_packages.dart';
import 'lab_test_list_page.dart';
import 'lab_test_static_data.dart';
import 'widgets/lab_test_app_bar.dart';

Widget _buildSymptomShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 6, // Show a few placeholders
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 12,
                color: Colors.white,
              ),
            ],
          );
        },
      ),
    ),
  );
}

class LabTestPage extends StatefulWidget {
  const LabTestPage({super.key});

  @override
  _LabTestPageState createState() => _LabTestPageState();
}

class _LabTestPageState extends State<LabTestPage> {
  int _searchTextIndex = 0;
  int _carouselIndex = 0;
  Timer? _searchTimer;
  // Removed _healthConcernTimer
  Timer? _carouselTimer;
  final PageController _carouselController = PageController();
  final tests = LabTestStaticData.popularTests;
  // final healthConcerns = LabTestStaticData.healthConcerns; // REMOVED: Using BLoC
  final offers = LabTestStaticData.offers;
  final checkupPlans = LabTestStaticData.checkupPlans;
  final planBanners = LabTestStaticData.planBanners;
  final searchTexts = LabTestStaticData.searchTexts;
  final carouselImages = LabTestStaticData.carouselImages;

  @override
  void initState() {
    super.initState();
    // 🚀 Dispatch the Symptom fetching event
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SymptomBloc>().add(FetchSymptomsEvent());
    });

    _startSearchAnimation();
    _startCarouselAnimation();
  }

  void _startSearchAnimation() {
    _searchTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _searchTextIndex = (_searchTextIndex + 1) % searchTexts.length;
      });
    });
  }

  void _startCarouselAnimation() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_carouselController.hasClients) {
        setState(() {
          _carouselIndex = (_carouselIndex + 1) % carouselImages.length;
        });
        _carouselController.animateToPage(
          _carouselIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _carouselTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  // Helper method to build a single symptom item using the Model
  Widget _buildSymptomItem(SymptomModel symptom) {
    // Check if ApiConstants.symptomImageBaseUrl is defined, if not, use a default
    const imageBaseUrl = ApiConstants.symptomImageBaseUrl;

    final imageUrl = symptom.symptomsImage != null && symptom.symptomsImage!.isNotEmpty
        ? '$imageBaseUrl${symptom.symptomsImage}'
        : null;

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(SlidePageRoute(page: LabTestListPage(symptomId: symptom.id, labName: "Symptom",)),);
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                          child: Icon(Icons.medication_outlined, size: 30, color: Colors.blueAccent));
                    },
                  )
                      : const Center(
                      child: Icon(Icons.medical_services_outlined, size: 30, color: Colors.blueAccent)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            symptom.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed Header with Search Bar
          LabTestAppBar(
            searchTexts: searchTexts,
            onBack: () {
              context.read<DashboardBloc>().add(DashboardTabChanged(0));
              // Also pop current cart page if it’s pushed on top
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Test by Health Concern Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Test by Symptoms',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ⭐️ Symptom BLoC Builder Integration
                  BlocBuilder<SymptomBloc, SymptomState>(
                    builder: (context, state) {
                      if (state is SymptomLoading || state is SymptomInitial) {
                        return _buildSymptomShimmer(); // Show shimmer
                      }
                      if (state is SymptomError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Failed to load symptoms.',
                              style: GoogleFonts.poppins(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      if (state is SymptomLoaded) {
                        final symptoms = state.symptoms;

                        if (symptoms.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'No symptoms data available.',
                                style: GoogleFonts.poppins(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: symptoms.length,
                            separatorBuilder: (context, index) =>
                            const SizedBox(width: 3),
                            itemBuilder: (context, index) {
                              return _buildSymptomItem(symptoms[index]);
                            },
                          ),
                        );
                      }
                      // Fallback for initial state before dispatch
                      return const SizedBox.shrink();
                    },
                  ),
                  // ---------------------------------------------

                  const SizedBox(height: 30),

                  // Carousel Slider Section 
                  SizedBox(
                    height: 180,
                    child: PageView.builder(
                      controller: _carouselController,
                      itemCount: carouselImages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _carouselIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return LabTestWidgets.buildCarouselItem(carouselImages[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Carousel Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: carouselImages.asMap().entries.map((entry) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _carouselIndex == entry.key ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _carouselIndex == entry.key
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // Offers for You Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Offers for You',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: offers.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return LabTestWidgets.buildOfferItem(offers[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // SizedBox(
                  //   height: 200,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: const EdgeInsets.symmetric(horizontal: 20),
                  //     itemCount: planBanners.length,
                  //     itemBuilder: (context, index) {
                  //       return SizedBox(
                  //         width:
                  //         MediaQuery.of(context).size.width *
                  //             0.8, // almost full width
                  //         child: LabTestWidgets.buildPlanBanner(planBanners[index]),
                  //       );
                  //     },
                  //   ),
                  // ),
                  //
                  // const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PopularTestPackages(),
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
}