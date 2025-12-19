import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/models/MedicineM/get_medicine_by_id_model.dart';
import 'package:medrpha_labs/models/PackagesM/package_detail_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Assuming these imports are correct based on your hint/project structure
import '../../../../models/TestM/test_detail_model.dart';
import '../../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../../views/Dashboard/dashboard_screen.dart';
import '../../../../views/Dashboard/widgets/slide_page_route.dart';
import '../../../../views/AppWidgets/app_snackbar.dart';
import '../../CartScreen/store/cart_notifier.dart';
import 'package:medrpha_labs/config/color/colors.dart'; // Assuming AppColors is available

class TestDetailAddToCartButton extends StatefulWidget {
  final TestDetailModel? testDetail;
  final PackageDetailModel? packageDetail;
  // ✅ Added medicineDetail to the widget properties
  final GetMedicineByIdModel? medicineDetail;

  const TestDetailAddToCartButton({
    super.key,
    this.testDetail,
    this.packageDetail,
    this.medicineDetail, // Made it nullable
  });

  @override
  State<TestDetailAddToCartButton> createState() => _TestDetailAddToCartButtonState();
}

class _TestDetailAddToCartButtonState extends State<TestDetailAddToCartButton> {
  int? _currentUserId;
  bool _isLoadingUserId = true;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    // Use 0 as the default if user_id is not found, indicating "not logged in"
    final id = prefs.getInt('user_id') ?? 0;

    if (mounted) {
      setState(() {
        _currentUserId = id;
        _isLoadingUserId = false;
      });
    }
  }

  void _handleLoginRequired() {
    // Navigate to Dashboard/Profile (index 4)
    Navigator.of(context).push(SlidePageRoute(page: const DashboardScreen(initialIndex: 4)));
    // Inform the dashboard BLoC to switch to the profile/login tab
    context.read<DashboardBloc>().add(DashboardTabChanged(4));
    showAppSnackBar(context, "You need to Login to add the product to your cart.");
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUserId) {
      return const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    // --- LOGIC TO SELECT MODEL DATA ---
    final bool isTestMode = widget.testDetail != null;
    final bool isPackageMode = widget.packageDetail != null;
    final bool isMedicineMode = widget.medicineDetail != null;

    // Must ensure exactly one model is present
    if (!isTestMode && !isPackageMode && !isMedicineMode) {
      return const Center(child: Text('Error: No product details provided.'));
    }

    // 2. Safely access the data source
    final int userId = _currentUserId!;

    final int productId;
    final int categoryId;
    final String name;
    final double discountedPrice;
    final double originalPrice;

    if (isMedicineMode) {
      // ✅ Use GetMedicineByIdModel properties
      final medicine = widget.medicineDetail!;
      productId = medicine.id;
      categoryId = 1; // 1 is a common placeholder for Medicine category ID
      name = medicine.product;
      discountedPrice = medicine.salePrice;
      originalPrice = medicine.mrpPrice;

    } else if (isTestMode) {
      // Use TestDetailModel properties
      final test = widget.testDetail!;
      productId = test.testID;
      categoryId = 2; // Category ID 2 for individual lab tests
      name = test.testName;
      discountedPrice = test.testPrice;
      // Placeholder price calculation for test detail (assuming 50% discount)
      originalPrice = discountedPrice * 2;

    } else {
      // Use PackageDetailModel properties
      final package = widget.packageDetail!;
      productId = package.packageId;
      categoryId = 3; // Category ID 3 for packages (Placeholder - adjust if needed)
      name = package.packageName;
      discountedPrice = package.packagePrice;
      originalPrice = package.totalPrice; // Total price before package discount
    }

    // Format prices for cart model
    final String originalPriceString = "₹${originalPrice.toStringAsFixed(0)}";
    final String discountedPriceString = "₹${discountedPrice.toStringAsFixed(0)}";
    // --- END OF LOGIC TO SELECT MODEL DATA ---

    final cart = Provider.of<CartProvider>(context);
    final int itemQtyInCart = cart.qty(name);
    final bool isThisProductLoading = cart.isProductLoading(productId);

    // --- Logic for Button Configuration ---

    // Initialize buttonChild to avoid the non-nullable variable error
    Widget buttonChild = const Center(child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));

    VoidCallback? onPressedHandler;
    Color buttonColor;
    String buttonText;
    IconData buttonIcon;

    if (userId == 0) {
      // User not logged in: show a button that leads to login
      buttonText = "Add to Cart (Login Required)";
      buttonIcon = Icons.add_shopping_cart;
      buttonColor = AppColors.primaryColor;
      onPressedHandler = _handleLoginRequired;

    } else if (isThisProductLoading) {
      // Product is loading/processing (e.g., waiting for API response)
      buttonText = "Processing...";
      buttonIcon = Icons.cached;
      buttonColor = AppColors.primaryColor.withOpacity(0.7);
      onPressedHandler = null;
      // buttonChild is used below to show the spinner

    } else if (itemQtyInCart > 0) {
      // Item is in cart: show Remove button
      buttonText = "Remove from Cart";
      buttonIcon = Icons.remove_shopping_cart;
      buttonColor = Colors.redAccent;
      onPressedHandler = () {
        cart.remove(
          categoryId: categoryId,
          userId: userId,
          productId: productId,
          name: name,
        );
      };

    } else {
      // Item not in cart: show Add button
      buttonText = "Add to Cart";
      buttonIcon = Icons.add_shopping_cart;
      buttonColor = AppColors.primaryColor;
      onPressedHandler = () {
        cart.add(
          categoryId: categoryId,
          userId: userId,
          productId: productId,
          name: name,
          originalPrice: originalPriceString,
          discountedPrice: discountedPriceString,
        );
      };
    }

    // --- Render Button ---

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: Colors.white,
          elevation: onPressedHandler == null ? 0 : 2,
        ),
        onPressed: onPressedHandler,
        // Conditionally hide the icon if loading
        icon: isThisProductLoading ? const SizedBox.shrink() : Icon(buttonIcon, size: 20),
        // Conditionally render the spinner or the text label
        label: isThisProductLoading
            ? buttonChild
            : Text(
          buttonText,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}