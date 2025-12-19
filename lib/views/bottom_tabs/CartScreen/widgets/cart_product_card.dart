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

    void handleAdd() {
      if  (productId != 0) {
        if (categoryId == 1) {
          cart.add1(widget.product.name, originalPrice, discountedPrice, 1);
        } else {
          cart.add(
            userId: userId,
            productId: productId,
            categoryId: categoryId,
            name: widget.product.name,
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
          );
        }
      }
    }

    void handleRemove() {
      if (productId != 0) {
        if (categoryId == 1) {
          cart.remove1(widget.product.name);
        } else {
          // Category 2 or default: Use API-backed method (Full Remove)
          cart.remove(
            userId: userId,
            productId: productId,
            name: widget.product.name, categoryId: 2,
          );
        }
      }
    }

    Widget buildQuantityControls(int currentQty) {
      if (categoryId == 1) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 16),
              padding: EdgeInsets.zero,
              onPressed: handleRemove,
            ),
            Text(
              '$currentQty',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 16),
              padding: EdgeInsets.zero,
              onPressed: handleAdd,
            ),
          ],
        );
      }
      else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: handleRemove,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.primaryColor,
              ),
              child: Text(
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

                  if (discountedPrice.isNotEmpty)
                    Text(
                      '₹$discountedPrice',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),

                  if (originalPrice.isNotEmpty)
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