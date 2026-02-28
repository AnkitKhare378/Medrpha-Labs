import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/apiConstant/api_constant.dart';
import '../../../../config/color/colors.dart';
import '../../../../config/routes/routes_name.dart';
import '../../../../models/TestM/lab_test.dart';
import '../../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../CartScreen/widgets/lab_mismatched_dialog.dart';
import '../../TestScreen/lab_test_detail_page.dart';

class AllPopularTestsPage extends StatefulWidget {
  final List<LabTest> tests;
  const AllPopularTestsPage({super.key, required this.tests});

  @override
  State<AllPopularTestsPage> createState() => _AllPopularTestsPageState();
}

class _AllPopularTestsPageState extends State<AllPopularTestsPage> {
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final cartCount = context.watch<CartProvider>().totalCount;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Popular Tests",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.tests.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.78, // Increased height for button row
        ),
        itemBuilder: (context, index) {
          return _buildGridTestCard(context, widget.tests[index]);
        },
      ),
      bottomNavigationBar: cartCount > 0 ? _buildBottomBar(context, cartCount) : null,
    );
  }

  Widget _buildGridTestCard(BuildContext context, LabTest test) {
    const placeholder = "https://cdn-icons-png.flaticon.com/128/5409/5409477.png";
    const imageBaseUrl = ApiConstants.testImageBaseUrl;

    final cart = Provider.of<CartProvider>(context);
    final int itemQtyInCart = cart.qty(test.testName);
    final bool isProductLoading = cart.isProductLoading(test.testID);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(SlidePageRoute(page: LabTestDetailPage(testId: test.testID))),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.network(
                  test.testImage.isNotEmpty ? "$imageBaseUrl${test.testImage}" : placeholder,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.network(placeholder),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              test.testName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 4),
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
    if (_userId == 0) {
      return _buildMiniButton(
        text: "Add",
        color: Colors.blueAccent,
        onTap: () {
          Navigator.of(context).push(SlidePageRoute(page: const DashboardScreen(initialIndex: 4)));
          context.read<DashboardBloc>().add(DashboardTabChanged(4));
          showAppSnackBar(context, "Please login to add tests to cart");
        },
      );
    }

    if (isLoading) {
      return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent)
      );
    }

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

  Widget _buildBottomBar(BuildContext context, int cartCount) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$cartCount item${cartCount > 1 ? 's' : ''} in cart',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () => Navigator.pushNamed(context, RoutesName.cartScreen),
              child: Text('Go to Cart', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniButton({required String text, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}