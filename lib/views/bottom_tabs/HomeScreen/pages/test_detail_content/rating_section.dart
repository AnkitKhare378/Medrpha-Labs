// lib/views/bottom_tabs/HomeScreen/widgets/test_detail_content/_rating_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/config/color/colors.dart';
import 'package:medrpha_labs/models/RatingM/get_rating_model.dart';
import 'package:medrpha_labs/view_model/RatingVM/get_rating_view_model.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/test_detail_content/rating_item_widget.dart';

class RatingSection extends StatelessWidget {
  final VoidCallback onRatingUpdated;

  const RatingSection({super.key, required this.onRatingUpdated});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRatingCubit, GetRatingState>(
      builder: (context, state) {
        if (state is GetRatingLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: CircularProgressIndicator(color: Colors.blueAccent),
            ),
          );
        }

        if (state is GetRatingError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Failed to load ratings: ${state.error}',
              style: GoogleFonts.poppins(color: Colors.redAccent),
            ),
          );
        }

        if (state is GetRatingLoaded) {
          if (state.ratings.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'No reviews yet. Be the first to rate this product!',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Reviews (${state.ratings.length})",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.ratings.length,
                itemBuilder: (context, index) {
                  final rating = state.ratings[index];
                  return RatingItemWidget(
                    rating: rating,
                    onRatingUpdated: onRatingUpdated,
                  );
                },
              ),
            ],
          );
        }

        // Initial state or unhandled state
        return const SizedBox.shrink();
      },
    );
  }
}