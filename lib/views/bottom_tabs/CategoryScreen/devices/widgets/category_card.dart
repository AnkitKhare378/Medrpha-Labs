import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../config/color/colors.dart';
import '../../../../../models/device_product.dart';
import 'shimmer_box.dart';

class CategoryCard extends StatefulWidget {
  final DeviceProduct product;
  final ValueChanged<int>? onCartChanged;

  const CategoryCard({
    Key? key,
    required this.product,
    this.onCartChanged,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  int _qty = 0;

  @override
  void initState() {
    super.initState();
    _loadQty();
  }

  Future<void> _loadQty() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _qty = prefs.getInt(widget.product.name) ?? 0);
  }

  Future<void> _saveQty(int qty) async {
    final prefs = await SharedPreferences.getInstance();
    if (qty == 0) {
      await prefs.remove(widget.product.name);
    } else {
      await prefs.setInt(widget.product.name, qty);
    }
    setState(() => _qty = qty);

    // recalc total cart count
    int total = 0;
    for (final key in prefs.getKeys()) {
      final v = prefs.getInt(key);
      if (v != null) total += v;
    }
    widget.onCartChanged?.call(total);
  }

  void _add() => _saveQty(_qty + 1);
  void _remove() => _saveQty(_qty > 0 ? _qty - 1 : 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (c, child, progress) =>
                  progress == null ? child : const ShimmerBox(),
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.medical_services,
                        color: AppColors.primaryColor, size: 30),
                  ),
                ),
              ),
            ),
          ),

          // Name + Add/Qty controls
          Expanded(
            flex: 2, // ⬆ extra space for the button
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  // _qty == 0
                  //     ? SizedBox(
                  //   height: 30,
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: _add,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: AppColors.primaryColor,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(6),
                  //       ),
                  //       padding: EdgeInsets.zero,
                  //       elevation: 0,
                  //     ),
                  //     child: Text(
                  //       'Add',
                  //       style: GoogleFonts.poppins(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // )
                  //     : Container(
                  //   height: 30,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: AppColors.primaryColor),
                  //     borderRadius: BorderRadius.circular(6),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       IconButton(
                  //         icon: const Icon(Icons.remove, size: 16),
                  //         padding: EdgeInsets.zero,
                  //         onPressed: _remove,
                  //       ),
                  //       Text(
                  //         '$_qty',
                  //         style: GoogleFonts.poppins(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //       IconButton(
                  //         icon: const Icon(Icons.add, size: 16),
                  //         padding: EdgeInsets.zero,
                  //         onPressed: _add,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
