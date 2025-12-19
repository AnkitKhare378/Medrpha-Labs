import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../../pages/dashboard/bloc/dashboard_event.dart';

class EmptyCartSection extends StatelessWidget {
  const EmptyCartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
          child: Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Image.network(
                'https://static.vecteezy.com/system/resources/previews/005/006/007/non_2x/no-item-in-the-shopping-cart-click-to-go-shopping-now-concept-illustration-flat-design-eps10-modern-graphic-element-for-landing-page-empty-state-ui-infographic-icon-vector.jpg',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(Icons.shopping_basket_outlined,
                    size: 60, color: Colors.purple),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'No items in your cart',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'It\'s never too late! Add items you saved for later,',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('or  ',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
            GestureDetector(
              onTap: () {
                // Move to Home Tab (index 0)
                context.read<DashboardBloc>().add(DashboardTabChanged(0));
                // Also pop current cart page if it’s pushed on top
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(
                'Continue Shopping',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Container(height: 8, color: Colors.grey[100]),
      ],
    );
  }
}
