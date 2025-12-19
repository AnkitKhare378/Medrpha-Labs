import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/widgets/test_card_shimmer.dart';
import 'package:medrpha_labs/views/exceptions/no_data_found_screen.dart';
import '../../../config/color/colors.dart';
import '../../../config/routes/routes_name.dart';
import '../../../data/repositories/test_service/test_search_service.dart';
import '../../../models/TestM/lab_test.dart';
import '../../../view_model/TestVM/TestSearch/lab_test_search_cubit.dart';
import '../../Dashboard/widgets/slide_page_route.dart';
import '../CartScreen/store/cart_notifier.dart';
import 'test_list_filter_page.dart';
import 'widgets/lab_test_app_bar.dart';
import 'widgets/sort_filter_button.dart';
import 'widgets/test_card.dart';

class LabTestListPage extends StatefulWidget {
  final int? labId;
  final int? symptomId;
  final String labName;

  const LabTestListPage({this.labId, this.symptomId,required this.labName, super.key});

  @override
  State<LabTestListPage> createState() => _LabTestListPageState();
}

class _LabTestListPageState extends State<LabTestListPage> {
  late int labId;
  int symptomId = 0;
  String searchName = '';

  @override
  void initState() {
    super.initState();
    labId = widget.labId ?? 0;
    symptomId = widget.symptomId ?? 0;
  }

  void _navigateToFilterPage() async {
    final int? newSymptomId = await Navigator.of(context).push(
      SlidePageRoute(
        page: TestFilterPage(
          initialSymptomId: symptomId,
          onApplyFilter: (id) {
            return id;
          },
        ),
      ),
    );

    if (newSymptomId != null && newSymptomId != symptomId) {
      setState(() {
        symptomId = newSymptomId;
      });

      print("Selected Symptom ID in LabTestListPage: $symptomId");

      context.read<LabTestSearchCubit>().searchLabTests(
        name: searchName,
        labId: labId,
        symptomId: symptomId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;
    return BlocProvider(
      key: ValueKey(symptomId),
      create: (context) {
        final cubit = LabTestSearchCubit(TestSearchService());
        cubit.searchLabTests(
          name: searchName,
          labId: labId,
          symptomId: symptomId,
        );
        return cubit;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              LabTestAppBar(
                searchTexts: const ["Blood", "Diabetes", "Full Body"],
                onBack: () => Navigator.pop(context),
                // Assuming LabTestAppBar has a search field that calls this when input changes
                // onSearchChanged: (value) => _performSearch(context, value),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Showing results for ${widget.labName}",
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        SortFilterButton(label: "Sort", icon: Iconsax.arrow_up_2, onPressed: () {/* handle sort */}),
                        const SizedBox(width: 10),
                        SortFilterButton(
                          label: "Filter",
                          icon: Iconsax.filter,
                          onPressed: _navigateToFilterPage, // **Use the new method**
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: BlocBuilder<LabTestSearchCubit, LabTestState>(
                  builder: (context, state) {
                    if (state is LabTestLoading) {
                      return const TestShimmer();
                    } else if (state is LabTestError) {
                      return Center(child: Text(state.message, style: GoogleFonts.poppins(color: Colors.red)));
                    } else if (state is LabTestLoaded) {
                      final List<LabTest> tests = state.tests;

                      if (tests.isEmpty) {
                        return const NoDataFoundScreen();
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
                    return Center(child: Text("Start searching for tests...", style: GoogleFonts.poppins()));
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