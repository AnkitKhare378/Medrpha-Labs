// lib/views/bottom_tabs/HomeScreen/pages/widgets/medicine_product_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/models/MedicineM/category_medicine_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../config/color/colors.dart';
import '../../../../../views/AppWidgets/app_snackbar.dart';
import '../../../../../views/Dashboard/dashboard_screen.dart';
import '../../../../../views/Dashboard/widgets/slide_page_route.dart';
import '../../../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../pages/medicine_detail_screen.dart';
// TODO: Ensure you import your CartProvider and MedicineDetailScreen

class CategoryMedicineProductCard extends StatefulWidget {
  final CategoryMedicineModel medicine;
  final VoidCallback? onTap;

  const CategoryMedicineProductCard({
    Key? key,
    required this.medicine,
    this.onTap,
  }) : super(key: key);

  @override
  State<CategoryMedicineProductCard> createState() => _CategoryMedicineProductCardState();
}

class _CategoryMedicineProductCardState extends State<CategoryMedicineProductCard> {
  int _userId = 0;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id') ?? 0;
    if (mounted) {
      setState(() {
        _userId = id;
        _isLoadingUser = false;
      });
    }
  }

  // --- Updated Helper Getters Based on Your Model ---
  String get _productName => widget.medicine.name ?? 'Medicine Name';
  String get _strength => widget.medicine.strength ?? '';

  // NOTE: Your model lacks price fields. Using placeholders or adding them if they exist in DB.
  // If your model is updated later, replace '0.00' with actual fields.
  String get _salePrice => "0.00";
  String get _mrpPrice => "0.00";

  String get _imageUrl => 'https://cdn-icons-png.flaticon.com/128/883/883407.png';

  String get _uniqueKey {
    final productId = widget.medicine.id ?? 0;
    return '$_productName|$productId';
  }

  static const int _medicineCategoryId = 2; // Matches your API response categoryId: 2

  void _handleLoginRequired(String message) {
    Navigator.of(context).push(SlidePageRoute(page: const DashboardScreen(initialIndex: 4)));
    context.read<DashboardBloc>().add(DashboardTabChanged(4));
    showAppSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    final cart = context.watch<CartProvider>();
    final qty = cart.qty(_uniqueKey);
    final productId = widget.medicine.id ?? 0;

    return GestureDetector(
      onTap: () {
           Navigator.of(context).push(SlidePageRoute(page: MedicineDetailScreen(
                medicineId: productId,
                productName: _productName,
          )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image & Prescription Tag
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 1.4,
                    child: Image.network(_imageUrl, fit: BoxFit.contain),
                  ),
                ),
                if (widget.medicine.isPrescription == true)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.red.withOpacity(0.8), borderRadius: BorderRadius.circular(4)),
                      child: Text("Rx", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _strength,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),

                  // Price Logic
                  Text('₹$_salePrice', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),

                  const SizedBox(height: 8),

                  // Cart / Login Button Logic
                  _buildActionButton(cart, productId, qty),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(CartProvider cart, int productId, int qty) {
    if (cart.isProductLoading(productId)) {
      return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
    }

    if (_userId == 0) {
      return _fullWidthButton(
        onPressed: () => _handleLoginRequired("Login to add to cart"),
        icon: Icons.login,
        label: "Login",
        color: Colors.blueAccent,
      );
    }

    if (qty == 0) {
      return _fullWidthButton(
        onPressed: () {
          cart.add(
            userId: _userId,
            productId: productId,
            name: _uniqueKey,
            categoryId: _medicineCategoryId,
            originalPrice: '₹$_mrpPrice',
            discountedPrice: '₹$_salePrice',
          );
          if(widget.medicine.isPrescription == true) {
            showAppSnackBar(context, "Prescription required for this medicine");
          }
        },
        icon: Icons.add,
        label: "Add",
        color: AppColors.primaryColor,
      );
    }

    return Container(
      height: 30,
      decoration: BoxDecoration(border: Border.all(color: AppColors.primaryColor), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            padding: EdgeInsets.zero,
            onPressed: () => cart.remove(userId: _userId, productId: productId, name: _uniqueKey, categoryId: _medicineCategoryId),
          ),
          Text('$qty', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            padding: EdgeInsets.zero,
            onPressed: () => cart.add(userId: _userId, productId: productId, name: _uniqueKey, categoryId: _medicineCategoryId, originalPrice: '₹$_mrpPrice', discountedPrice: '₹$_salePrice'),
          ),
        ],
      ),
    );
  }

  Widget _fullWidthButton({required VoidCallback onPressed, required IconData icon, required String label, required Color color}) {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}