// lib/views/bottom_tabs/HomeScreen/widgets/test_detail_content/_rating_item_widget.dart (UPDATED)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/config/color/colors.dart';
import 'package:medrpha_labs/models/RatingM/get_rating_model.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/edit_rating_screen.dart';
import 'package:medrpha_labs/views/Dashboard/widgets/slide_page_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../view_model/RatingVM/rating_delete_view_model.dart';
import 'star_rating_row.dart';

class RatingItemWidget extends StatelessWidget {
  final RatingDetailModel rating;
  final VoidCallback onRatingUpdated;

  const RatingItemWidget({
    super.key,
    required this.rating,
    required this.onRatingUpdated,
  });

  Future<int?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  // --- DELETE LOGIC ---
  Future<void> _confirmAndDelete(BuildContext context) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this rating? This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      // Use the Cubit to perform the deletion
      await context.read<RatingDeleteCubit>().deleteRating(rating.id);

      // Listen for the state change immediately after the call
      final state = context.read<RatingDeleteCubit>().state;
      if (state is RatingDeleteSuccess) {
        // Show success message and refresh the parent list
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
        onRatingUpdated();
      } else if (state is RatingDeleteError) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
        );
      }
    }
  }
  // --- END DELETE LOGIC ---

  @override
  Widget build(BuildContext context) {
    print(rating.createdBy);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StarRatingRow(ratingPoint: rating.ratingpoint),

              // Use FutureBuilder to check ownership
              FutureBuilder<int?>(
                future: _getCurrentUserId(),
                builder: (context, snapshot) {
                  final currentUserId = snapshot.data;
                  // Convert String createdBy to int safely
                  final creatorId = int.tryParse(rating.createdBy) ?? -1;

                  // Only show icons if IDs match
                  if (currentUserId != null && currentUserId == creatorId) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Navigator.of(context).push(SlidePageRoute(
                              page: EditReviewFormScreen(
                                categoryId: rating.categoryId,
                                productId: rating.productId,
                                ratingId: rating.id,
                                remark: rating.remark,
                                ratingPoint: rating.ratingpoint.toInt(),
                              ),
                            ));
                            onRatingUpdated();
                          },
                          icon: const Icon(Icons.edit_note_rounded),
                        ),
                        IconButton(
                          onPressed: () => _confirmAndDelete(context),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    );
                  }
                  // Return empty space if not the owner
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
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