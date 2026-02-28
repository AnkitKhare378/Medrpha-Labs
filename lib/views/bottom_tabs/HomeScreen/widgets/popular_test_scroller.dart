import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/apiConstant/api_constant.dart';
import '../../../../models/TestM/lab_test.dart';
import '../../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../../view_model/TestVM/AllLabTest/lab_test_cubit.dart';
import '../../../../view_model/TestVM/AllLabTest/lab_test_state.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../CartScreen/widgets/lab_mismatched_dialog.dart';
import '../../TestScreen/lab_test_detail_page.dart';
import '../all_pages/all_popular_test_page.dart';

class PopularTestScroller extends StatefulWidget {
  const PopularTestScroller({super.key});

  @override
  State<PopularTestScroller> createState() => _PopularTestScrollerState();
}

class _PopularTestScrollerState extends State<PopularTestScroller> {
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    context.read<AllTestCubit>().loadAllTests();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userId = prefs.getInt('user_id') ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.40;
    // Increased height to accommodate the new button row
    final cardHeight = screenWidth * 0.55;

    return BlocBuilder<AllTestCubit, AllTestState>(
      builder: (context, state) {
        if (state is AllTestLoading) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        } else if (state is AllTestLoaded) {
          final popularTests = state.test.where((test) => test.isPopular).toList();

          if (popularTests.isEmpty) return const SizedBox.shrink();

          final int displayLimit = 6;
          final bool hasMore = popularTests.length > displayLimit;
          final int itemCount = hasMore ? displayLimit + 1 : popularTests.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Tests",
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, SlidePageRoute(page: AllPopularTestsPage(tests: popularTests)));
                      },
                      child: Text(
                        "View All",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: cardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: itemCount,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    if (hasMore && index == displayLimit) {
                      return _buildMoreCard(context, popularTests, cardWidth);
                    }
                    return _buildTestCard(context, popularTests[index], cardWidth);
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTestCard(BuildContext context, LabTest test, double width) {
    const placeholder = "https://cdn-icons-png.flaticon.com/128/5409/5409477.png";
    const imageBaseUrl = ApiConstants.testImageBaseUrl;

    final cart = Provider.of<CartProvider>(context);
    final int itemQtyInCart = cart.qty(test.testName);
    final bool isProductLoading = cart.isProductLoading(test.testID);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(SlidePageRoute(page: LabTestDetailPage(testId: test.testID)));
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    test.testImage.isNotEmpty ? "$imageBaseUrl${test.testImage}" : placeholder,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.network(placeholder),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              test.testName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${test.testPrice.toInt()}",
                  style: GoogleFonts.poppins(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                  ),
                ),
                _buildCartAction(context, cart, test, itemQtyInCart, isProductLoading),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartAction(BuildContext context, CartProvider cart, LabTest test, int qty, bool isLoading) {
    // 1. Guest User Logic
    if (_userId == 0) {
      return _buildMiniButton(
        text: "+ Add",
        color: Colors.blueAccent,
        onTap: () {
          Navigator.of(context).push(SlidePageRoute(page: const DashboardScreen(initialIndex: 4)));
          context.read<DashboardBloc>().add(DashboardTabChanged(4));
          showAppSnackBar(context, "Please login to add tests to cart");
        },
      );
    }

    // 2. Loading State
    if (isLoading) {
      return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent)
      );
    }

    // 3. Add/Remove Toggle
    bool alreadyInCart = qty > 0;
    return _buildMiniButton(
      text: alreadyInCart ? "Remove" : "Add",
      color: alreadyInCart ? Colors.redAccent : Colors.blueAccent,
      onTap: () async {
        if (alreadyInCart) {
          cart.remove(
            categoryId: 2,
            userId: _userId,
            labId: test.labId,
            productId: test.testID,
            name: test.testName,
          );
        } else {
          try {
            await cart.add(
              categoryId: 2,
              userId: _userId,
              labId: test.labId,
              productId: test.testID,
              name: test.testName,
              originalPrice: test.sellingPrice,
              discountedPrice: test.testPrice,
            );
          } catch (e) {
            if (e.toString() == 'LAB_MISMATCH') {
              showDialog(
                context: context,
                builder: (context) => LabMismatchedDialog(
                  cartProvider: cart,
                  userId: _userId,
                  productId: test.testID,
                  name: test.testName,
                  categoryId: 2,
                  labId: test.labId,
                  labName: test.testName,
                  originalPrice: test.testPrice,
                  discountedPrice: test.testPrice,
                ),
              );
            }
          }
        }
      },
    );
  }

  Widget _buildMiniButton({required String text, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        // Increased horizontal padding for a better text-button look
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMoreCard(BuildContext context, List<LabTest> tests, double width) {
    return GestureDetector(
      onTap: () => Navigator.push(context, SlidePageRoute(page: AllPopularTestsPage(tests: tests))),
      child: Container(
        width: width * 0.8,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(
                "View More",
                style: GoogleFonts.poppins(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w500)
            ),
          ],
        ),
      ),
    );
  }
}