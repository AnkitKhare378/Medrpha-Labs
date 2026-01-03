// lib/views/bottom_tabs/HomeScreen/pages/widgets/medicine_product_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/models/MedicineM/store_medicine_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../config/color/colors.dart'; // For AppColors.primaryColor
import '../../../../../models/MedicineM/get_medicine_by_company_model.dart'; // The model
import '../../../../../views/AppWidgets/app_snackbar.dart'; // For showAppSnackBar
import '../../../../../views/Dashboard/dashboard_screen.dart';
import '../../../../../views/Dashboard/widgets/slide_page_route.dart';
import '../../../../../pages/dashboard/bloc/dashboard_bloc.dart'; // For DashboardBloc
import '../../../../../pages/dashboard/bloc/dashboard_event.dart'; // For DashboardTabChanged
import '../../../CartScreen/store/cart_notifier.dart'; // For CartProvider
import '../medicine_detail_screen.dart'; // For navigation

class MedicineProductCard extends StatefulWidget {
  final StoreMedicineModel medicine;
  final VoidCallback? onTap;

  const MedicineProductCard({
    Key? key,
    required this.medicine,
    this.onTap,
  }) : super(key: key);

  @override
  State<MedicineProductCard> createState() => _MedicineProductCardState();
}

class _MedicineProductCardState extends State<MedicineProductCard> {
  int _userId = 0; // Default to 0 (not logged in)
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    // Use 0 if user_id is not found (not logged in)
    final id = prefs.getInt('user_id') ?? 0;

    if (mounted) {
      setState(() {
        _userId = id;
        _isLoadingUser = false;
      });
    }
  }

  // --- Helper Getters ---
  String get _productName => widget.medicine.product ?? 'Medicine Name';
  String get _salePrice => widget.medicine.salePrice?.toStringAsFixed(2) ?? '0.00';
  String get _mrpPrice => widget.medicine.mrpPrice?.toStringAsFixed(2) ?? '0.00';
  String get _imageUrl => 'https://via.placeholder.com/160';

  // ✅ Fix for CartProvider keying issue: Create a unique key string
  String get _uniqueKey {
    final productId = widget.medicine.id ?? 0;
    // Format: "Medicine Name|12345"
    return '$_productName|$productId';
  }

  // Medicine Category ID placeholder
  static const int _medicineCategoryId = 1;

  void _handleLoginRequired(String message) {
    Navigator.of(context).push(SlidePageRoute(page: const DashboardScreen(initialIndex: 4)));
    // Inform the dashboard BLoC to switch to the profile/login tab
    context.read<DashboardBloc>().add(DashboardTabChanged(4));
    showAppSnackBar(context, message);
  }
  // -------------------------

  @override
  Widget build(BuildContext context) {
    // If user ID is still loading, show a basic loading indicator
    if (_isLoadingUser) {
      return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    final cart = context.watch<CartProvider>();
    // ✅ Use the unique key for checking quantity
    final qty = cart.qty(_uniqueKey);

    final productId = widget.medicine.id ?? 0;
    final originalPriceString = '₹$_mrpPrice';
    final discountedPriceString = '₹$_salePrice';

    // Check if the item is currently being processed by an API call
    final bool isProductLoading = cart.isProductLoading(productId);

    return GestureDetector(
      onTap: () {
        // Use the onTap provided by the parent view
        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          // Fallback navigation to detail screen
          Navigator.of(context).push(
            SlidePageRoute(
              page: MedicineDetailScreen(
                medicineId: productId,
                productName: _productName,
              ),
            ),
          );
        }
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (existing code)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: Image.network(
                  _imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey, size: 40),
                  ),
                ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price
                  Row(
                    children: [
                      Text('₹$_salePrice', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryColor,)),
                      const SizedBox(width: 8),
                      if (widget.medicine.mrpPrice != null && widget.medicine.mrpPrice! > widget.medicine.salePrice!)
                        Text('₹$_mrpPrice', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough,)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  if(isProductLoading)
                    const SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: Center(
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2)
                          )
                      ),
                    )
                  else if (_userId == 0)
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: ElevatedButton.icon(
                        onPressed: () => _handleLoginRequired("You need to Login to add medicine to your cart."),
                        icon: const Icon(Icons.login, size: 16),
                        label: const Text("Login"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: EdgeInsets.zero,
                          textStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  else if (qty == 0)
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: ElevatedButton.icon(
                          onPressed: () => {
                            cart.add(
                              userId: _userId,
                              productId: productId,
                              name: _uniqueKey,
                              categoryId: _medicineCategoryId,
                              originalPrice: originalPriceString,
                              discountedPrice: discountedPriceString,
                            ),
                            showAppSnackBar(context, "This medicine is prescribed"),
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text("Add"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: EdgeInsets.zero,
                            textStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    else // Item is in cart
                      Container(
                        height: 28,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              padding: EdgeInsets.zero,
                              onPressed: () => cart.remove(
                                userId: _userId,
                                productId: productId,
                                name: _uniqueKey, // ✅ Use unique key
                                categoryId: _medicineCategoryId,
                              ),
                            ),
                            Text(
                              '$qty',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              padding: EdgeInsets.zero,
                              onPressed: () => cart.add(
                                userId: _userId,
                                productId: productId,
                                name: _uniqueKey, // ✅ Use unique key
                                categoryId: _medicineCategoryId,
                                originalPrice: originalPriceString,
                                discountedPrice: discountedPriceString,
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}