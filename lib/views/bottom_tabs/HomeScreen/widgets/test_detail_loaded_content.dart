// lib/views/bottom_tabs/HomeScreen/widgets/test_detail_content/test_detail_content_and_ratings.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../config/color/colors.dart';
import '../../../../../models/RatingM/get_rating_model.dart';
import '../../../../../models/TestM/test_detail_model.dart';
import '../../../../../view_model/RatingVM/get_rating_view_model.dart';
import '../../../Dashboard/pages/location_picker_screen.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../pages/review_screen.dart';
import '../pages/test_detail_content/info_chip_widget.dart';
import '../pages/test_detail_content/rating_section.dart';
import 'related_test_slider.dart';
import 'test_detail_add_to_cart_button.dart';

class TestDetailContentAndRatings extends StatefulWidget {
  final TestDetailModel detail;

  const TestDetailContentAndRatings({super.key, required this.detail});

  @override
  State<TestDetailContentAndRatings> createState() => _TestDetailContentAndRatingsState();
}

class _TestDetailContentAndRatingsState extends State<TestDetailContentAndRatings> {
  int? _userId;
  String _selectedAddress = "Loading location..."; // 👈 Added default address state

  @override
  void initState() {
    super.initState();
    _loadInitialData().then((_) {
      _fetchRatings();
    });
  }

  void _fetchRatings() {
    context.read<GetRatingCubit>().fetchRatings(
      categoryId: widget.detail.categoryID,
      productId: widget.detail.testID,
    );
  }

  // Combined User ID and Address fetching
  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id');
      // Fetch dynamic address from SharedPreferences
      _selectedAddress = prefs.getString('selected_address') ?? "No address selected";
    });
  }

  // Logic to allow user to change location manually from this screen
  void _changeLocation() async {
    final result = await Navigator.of(context).push(
      SlidePageRoute(page: const LocationPickerScreen()),
    );

    if (result != null) {
      // Refresh address after coming back from picker
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedAddress = prefs.getString('selected_address') ?? "No address selected";
      });
    }
  }

  // ... (Coupons and _hasUserRated logic remains the same) ...
  Widget _buildCouponContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        "Apply COUPON10 for 10% off!",
        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryColor),
      ),
    );
  }

  bool _hasUserRated(GetRatingState state) {
    if (state is GetRatingLoaded && _userId != null) {
      final detail = widget.detail;
      final userIdString = _userId.toString();

      return state.ratings.any((rating) =>
      rating.categoryId == detail.categoryID &&
          rating.productId == detail.testID &&
          rating.createdBy == userIdString
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final discountedPrice = detail.testPrice;
    final originalPrice = discountedPrice * 2;
    const discountPercent = 50;

    final ratingState = context.watch<GetRatingCubit>().state;
    final bool userHasRated = _hasUserRated(ratingState);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... (Header, Chips, Price, and Add to Cart button remain unchanged) ...
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network("${ApiConstants.testImageBaseUrl}${detail.testImage}", height: 30, fit: BoxFit.cover,)
                  )
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.departmentName,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail.testName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        InfoChipWidget("Category: ${detail.categoryName}"),
                        InfoChipWidget("Sample: ${detail.sampleName}", icon: Iconsax.safe_home),
                        if (detail.isFasting)
                          InfoChipWidget("Fasting Required", icon: Iconsax.warning_2),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Text(
                "₹${discountedPrice.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
              ),
              const SizedBox(width: 8),
              Text(
                "₹${originalPrice.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
              ),
              const SizedBox(width: 8),
              Text(
                "$discountPercent% OFF",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.pink, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TestDetailAddToCartButton(testDetail: detail, packageDetail: null,),
          const SizedBox(height: 25),

          // --- Description and Ranges (keeping your layout) ---
          Text("Test Description", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(detail.description, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 16),
          Text("Normal Range / Unit", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Range: ${detail.normalRange} | Unit: ${detail.unitName}", style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 25),

          // --- Sample Collection Location (DYNAMIC UPDATED) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( // Added expanded to prevent text overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sample Test Collection",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _selectedAddress,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _changeLocation,
                icon: Icon(Icons.edit, color: AppColors.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(),

          RatingSection(onRatingUpdated: _fetchRatings),
          if (!userHasRated && ratingState is! GetRatingLoading)
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber,),
                TextButton(
                  onPressed: () async {
                    await Navigator.of(context).push(SlidePageRoute(
                        page: ReviewFormScreen(
                          categoryId: detail.categoryID,
                          productId: detail.testID,
                        )
                    ));
                    _fetchRatings();
                  },
                  child: Text(
                      "Tap Here To Rate this Product",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
              ],
            ),
          RelatedTestsSlider(testId: detail.testID),
        ],
      ),
    );
  }
}