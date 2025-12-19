import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/widgets/test_card_shimmer.dart';
import '../../../config/color/colors.dart';
import '../../../config/routes/routes_name.dart';
import '../../../data/repositories/test_service/test_service.dart';
import '../../../models/TestM/lab_test.dart';
import '../../../view_model/TestVM/AllLabTest/lab_test_cubit.dart';
import '../../../view_model/TestVM/AllLabTest/lab_test_state.dart';
import '../CartScreen/store/cart_notifier.dart';
import 'widgets/lab_test_app_bar.dart';
import 'widgets/sort_filter_button.dart';
import 'widgets/test_card.dart';

class AllTestListPage extends StatelessWidget {
  const AllTestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;
    return BlocProvider(
      create: (context) =>
          AllTestCubit(TestService())
            ..loadAllTests(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              LabTestAppBar(
                searchTexts: const ["Blood", "Diabetes", "Full Body"],
                onBack: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Showing all available Lab Tests", // Updated text for dynamic data
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        SortFilterButton(
                          label: "Sort",
                          icon: Iconsax.arrow_up_2,
                          onPressed: () {
                            /* handle sort */
                          },
                        ),
                        const SizedBox(width: 10),
                        SortFilterButton(
                          label: "Filter",
                          icon: Iconsax.filter,
                          onPressed: () {
                            /* handle filter */
                          },
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
                      return const Center(child: TestShimmer());
                    } else if (state is AllTestError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    } else if (state is AllTestLoaded) {
                      final List<LabTest> tests = state.test;

                      if (tests.isEmpty) {
                        return const Center(child: Text("No tests found."));
                      }

                      return ListView.builder(
                        itemCount: tests.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final test = tests[index];
                          return TestCard(test: test);
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        "Loading test list...",
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  },
                ),
              ),
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
