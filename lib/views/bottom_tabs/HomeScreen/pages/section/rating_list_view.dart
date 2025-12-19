import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/color/colors.dart';
import '../../../../../models/RatingM/get_rating_model.dart';
import '../../../../../view_model/RatingVM/get_rating_view_model.dart';

class RatingListView extends StatefulWidget {
  final int categoryId;
  final int productId;

  const RatingListView({
    super.key,
    required this.categoryId,
    required this.productId,
  });

  @override
  State<RatingListView> createState() => _RatingListViewState();
}

class _RatingListViewState extends State<RatingListView> {
  @override
  void initState() {
    super.initState();
    // Start fetching ratings when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetRatingCubit>().fetchRatings(
        categoryId: widget.categoryId,
        productId: widget.productId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRatingCubit, GetRatingState>(
      builder: (context, state) {
        if (state is GetRatingLoading) {
          return const Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: CircularProgressIndicator(color: Colors.blueAccent),
          ));
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
                physics: const NeverScrollableScrollPhysics(), // Important for nested scroll views
                shrinkWrap: true,
                itemCount: state.ratings.length,
                itemBuilder: (context, index) {
                  final rating = state.ratings[index];
                  return _RatingItem(rating: rating);
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

class _RatingItem extends StatelessWidget {
  final RatingDetailModel rating;

  const _RatingItem({required this.rating});

  // Helper to build stars
  Widget _buildStars(double ratingPoint) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < ratingPoint ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format the date
    final date = '${rating.createdDate.day}/${rating.createdDate.month}/${rating.createdDate.year}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rating.userName,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildStars(rating.ratingpoint),
          const SizedBox(height: 6),
          Text(
            rating.remark,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}