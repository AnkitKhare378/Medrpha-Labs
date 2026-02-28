import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/config/color/colors.dart';

class CouponWidget extends StatefulWidget {
  final Function(String code, double discount) onApplied;

  const CouponWidget({Key? key, required this.onApplied}) : super(key: key);

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  final TextEditingController _controller = TextEditingController();
  String? appliedCode;

  // Static list of coupons
  final List<Map<String, dynamic>> staticCoupons = [
    {'code': 'FIRST50', 'desc': '50% Off on your first order', 'value': 50.0},
    {'code': 'LABTEST20', 'desc': 'Flat ₹200 off on services', 'value': 200.0},
    {'code': 'FREESHIP', 'desc': 'Free Delivery on all orders', 'value': 0.0},
  ];

  void _applyCoupon(String code, double discount) {
    setState(() {
      appliedCode = code;
      _controller.text = code;
    });

    // Trigger Success Effect
    _showSuccessEffect(code);
    widget.onApplied(code, discount);
  }

  void _showSuccessEffect(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "'$code' applied successfully!",
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCouponList() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Available Coupons",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              ...staticCoupons.map((coupon) => Card(
                elevation: 0,
                color: Colors.blue.shade50,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.blue.shade100)
                ),
                child: ListTile(
                  title: Text(coupon['code'],
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                  subtitle: Text(coupon['desc'], style: GoogleFonts.poppins(fontSize: 12)),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _applyCoupon(coupon['code'], coupon['value']);
                    },
                    child: Text("APPLY", style: GoogleFonts.poppins(color: AppColors.primaryColor),),
                  ),
                ),
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, color: Colors.blueAccent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter Coupon Code",
                    hintStyle: GoogleFonts.poppins(fontSize: 13),
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _applyCoupon(_controller.text, 0.0);
                  }
                },
                child: Text("APPLY",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              ),
            ],
          ),
          const Divider(),
          GestureDetector(
            onTap: _showCouponList,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("View more coupons",
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black54),
              ],
            ),
          )
        ],
      ),
    );
  }
}