import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/pages/save_for_later_page.dart';

import '../../../../config/color/colors.dart';

class CartHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const CartHeader({Key? key, required this.onBack}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'My Cart',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // const Icon(Iconsax.search_normal, color: Colors.white, size: 20),
              // const SizedBox(width: 16),
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SaveForLaterPage()));
                  },
                  child: const Icon(Iconsax.bookmark, color: Colors.white, size: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
