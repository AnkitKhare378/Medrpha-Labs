import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/AppWidgets/app_snackbar.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/grid_button.dart';
import '../../../../config/color/colors.dart';
// Updated Service Import
import '../../../../data/repositories/rating_service/rating_update_service.dart';
// Updated Cubit Import
import '../../../../view_model/RatingVM/rating_update_view_model.dart';


class EditReviewFormScreen extends StatelessWidget {
  final int categoryId;
  final int productId;
  final int ratingId;
  final String remark;
  final int ratingPoint;

  const EditReviewFormScreen({
    super.key,
    required this.categoryId,
    required this.productId,
    required this.ratingId,
    required this.remark,
    required this.ratingPoint,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Use the new RatingUpdateCubit and Service
    return BlocProvider(
      create: (context) => RatingUpdateCubit(RatingUpdateService()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          // 2. Pass initial data to ReviewForm
          child: ReviewForm(
            categoryId: categoryId,
            productId: productId,
            ratingId: ratingId,
            initialRemark: remark,
            initialRatingPoint: ratingPoint,
          ),
        ),
      ),
    );
  }
}

class ReviewForm extends StatefulWidget {
  final int categoryId;
  final int productId;
  final int ratingId;
  final String initialRemark;
  final int initialRatingPoint;

  const ReviewForm({
    super.key,
    required this.categoryId,
    required this.productId,
    required this.ratingId,
    required this.initialRemark,
    required this.initialRatingPoint,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRatingPoint;
    _reviewController.text = widget.initialRemark;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview(BuildContext context) {
    if (_selectedRating == 0) {
      showAppSnackBar(context, "Please select a star rating");
      return;
    }

    context.read<RatingUpdateCubit>().updateRating(
      ratingId: widget.ratingId,
      remark: _reviewController.text.trim(),
      ratingPoint: _selectedRating,
      categoryId: widget.categoryId,
      productId: widget.productId,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 4. Listen to the RatingUpdateCubit state
    return BlocConsumer<RatingUpdateCubit, RatingUpdateState>(
      listener: (context, state) {
        if (state is RatingUpdateSuccess) {
          showAppSnackBar(context, state.message);
          // Close the screen after successful update
          Navigator.pop(context);
        } else if (state is RatingUpdateError) {
          showAppSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        final isLoading = state is RatingUpdateLoading;

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Review', // Changed title
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.primaryColor, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStarRating(isLoading),
              const SizedBox(height: 8),
              Text(
                'Tap to change rating',
                style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),
              _buildLabel('Product review'),
              _buildTextField(
                controller: _reviewController,
                maxLines: 4,
                height: 120,
                keyboardType: TextInputType.multiline,
                enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GridButton(
                      text: isLoading ? "UPDATING..." : "UPDATE PRODUCT REVIEW",
                      backgroundColor: isLoading ? Colors.grey : AppColors.primaryColor,
                      textColor: Colors.white,
                      borderColor: isLoading ? Colors.grey : AppColors.primaryColor,
                      onPressed: isLoading ? null : () => _submitReview(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // --- UI Helpers ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildStarRating(bool disabled) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final ratingValue = index + 1;
        return IconButton(
          onPressed: disabled ? null : () {
            setState(() {
              _selectedRating = ratingValue;
            });
          },
          icon: Icon(
            ratingValue <= _selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
            color: ratingValue <= _selectedRating ? Colors.amber : const Color(0xFFE2E8F0),
            size: 36,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    int maxLines = 1,
    double height = 48,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.top,
        style: GoogleFonts.poppins(color: Colors.black87),
        enabled: enabled,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.poppins(color: const Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: maxLines > 1 ? 12 : 8,
          ),
        ),
      ),
    );
  }
}