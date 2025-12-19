import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/color/colors.dart';

class AddButton extends StatefulWidget {
  final ValueChanged<int>? onQuantityChanged; // callback if you need it outside
  final double height;

  const AddButton({
    Key? key,
    this.onQuantityChanged,
    this.height = 28,
  }) : super(key: key);

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  int _qty = 0;

  void _increment() {
    setState(() => _qty++);
    widget.onQuantityChanged?.call(_qty);
  }

  void _decrement() {
    if (_qty > 1) {
      setState(() => _qty--);
      widget.onQuantityChanged?.call(_qty);
    } else {
      // back to 0 → show Add button again
      setState(() => _qty = 0);
      widget.onQuantityChanged?.call(_qty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: _qty == 0
          ? ElevatedButton(
        onPressed: _increment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Text(
          'Add',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      )
          : Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 16),
              color: AppColors.primaryColor,
              padding: EdgeInsets.zero,
              onPressed: _decrement,
            ),
            Text(
              '$_qty',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 16),
              color: AppColors.primaryColor,
              padding: EdgeInsets.zero,
              onPressed: _increment,
            ),
          ],
        ),
      ),
    );
  }
}
