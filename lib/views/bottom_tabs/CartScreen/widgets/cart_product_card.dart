import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../config/color/colors.dart';
import '../../../../../models/device_product.dart';
import '../store/cart_notifier.dart';

class CartProductCard extends StatefulWidget {
  final DeviceProduct product;

  const CartProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  int? _currentUserId = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');

    if (mounted) {
      setState(() {
        _currentUserId = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final cartItem = cart.items[widget.product.name];
    final qty = cartItem?.qty ?? 0;

    if (qty <= 0) return const SizedBox.shrink();

    final discountedPrice = cartItem?.discountedPrice ?? widget.product.discountedPrice;
    final originalPrice = cartItem?.originalPrice ?? widget.product.originalPrice;

    final int productId = cartItem?.productId ?? 0;
    final int categoryId = cartItem?.categoryId ?? 0; // Get category ID
    final int userId = _currentUserId ?? 0;
    final int? labId = cartItem?.labId;

    void handleAdd() {
      if (productId != 0) {
        // Logic Swapped: Category 1 now uses the main 'add' method
        if (categoryId == 1) {
          cart.add(
            userId: userId,
            productId: productId,
            categoryId: categoryId,
            labId: labId ?? 0,
            name: widget.product.name,
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
          );
        } else {
          // Others use add1
          cart.add1(
            widget.product.name,
            1,
            originalPrice,
            discountedPrice,
            categoryId,
          );
        }
      }
    }

    void handleRemove() {
      if (productId != 0) {
        // Logic Swapped: Category 1 now uses the main 'remove' method
        if (categoryId == 1) {
          cart.remove(
            userId: userId,
            labId: labId ?? 0,
            productId: productId,
            name: widget.product.name,
            categoryId: categoryId,
          );
        } else {
          cart.remove(
            userId: userId,
            labId: labId ?? 0,
            productId: productId,
            name: widget.product.name,
            categoryId: categoryId,
          );
        }
      }
    }

    Widget buildQuantityControls(int currentQty) {
      // Check if this specific product is currently hitting the API
      final bool isLoading = cart.isProductLoading(productId);

      if (categoryId == 1) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              // Disable button if loading
              icon: Icon(Icons.remove, size: 16, color: isLoading ? Colors.grey : AppColors.primaryColor),
              padding: EdgeInsets.zero,
              onPressed: isLoading ? null : handleRemove,
            ),
            // Show loader in place of the number
            SizedBox(
              width: 20,
              child: isLoading
                  ? const Center(
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                ),
              )
                  : Text(
                '$currentQty',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              // Disable button if loading
              icon: Icon(Icons.add, size: 16, color: isLoading ? Colors.grey : AppColors.primaryColor),
              padding: EdgeInsets.zero,
              onPressed: isLoading ? null : handleAdd,
            ),
          ],
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: isLoading ? null : handleRemove,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.primaryColor,
              ),
              child: isLoading
                  ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text(
                'Remove',
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      }
    }

    // --- Main Widget Build ---
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                    Text(
                      '₹$discountedPrice',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),


                    Text(
                      '₹$originalPrice',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ✅ Conditional Quantity controls container
            Container(
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: buildQuantityControls(qty), // <-- Use the conditional widget
            ),
          ],
        ),
      ),
    );
  }
}