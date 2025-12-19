// lab_test_detail_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/config/color/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/routes/routes_name.dart';
import '../../../data/repositories/test_service/test_detail_service.dart';
import '../../../view_model/TestVM/TestDetail/test_detail_view_model.dart';
import '../CartScreen/store/cart_notifier.dart';
import '../HomeScreen/widgets/test_detail_content_manager.dart';
import '../HomeScreen/widgets/test_detail_search_bar.dart';

class LabTestDetailPage extends StatelessWidget {
  final int testId;

  const LabTestDetailPage({super.key, required this.testId});

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;
    return BlocProvider(
      create: (context) => TestDetailBloc(TestDetailService())
        ..add(FetchTestDetail(testId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Lab Test Details",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Search Bar Widget
              TestDetailSearchBar(),

              // 2. BLoC Content Manager (handles Loading/Error/Loaded states)
              TestDetailContentManager(),
            ],
          ),
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
      ),
    );
  }
}