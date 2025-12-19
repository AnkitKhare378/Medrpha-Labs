import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/AppWidgets/app_snackbar.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/grid_button.dart';
import '../../../../config/color/colors.dart';
import '../../../../data/repositories/rating_service/insert_rating_service.dart';
import '../../../../view_model/RatingVM/insert_rating_view_model.dart';

class ReviewFormScreen extends StatelessWidget {
  final int categoryId;
  final int productId;
  const ReviewFormScreen({super.key, required this.categoryId, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InsertRatingCubit(InsertRatingService()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReviewForm(categoryId: categoryId, productId: productId),
        ),
      ),
    );
  }
}

class ReviewForm extends StatefulWidget {
  final int categoryId;
  final int productId;
  const ReviewForm({super.key, required this.categoryId, required this.productId});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  void _submitReview(BuildContext context) {
    if (_selectedRating == 0) {
      showAppSnackBar(context, "Please select satr rating");
      return;
    }

    context.read<InsertRatingCubit>().submitRating(
      remark: _reviewController.text.trim(),
      ratingpoint: _selectedRating,
      categoryId: widget.categoryId,
      productId: widget.productId,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocConsumer to listen to state changes and rebuild the UI
    return BlocConsumer<InsertRatingCubit, InsertRatingState>(
      listener: (context, state) {
        if (state is InsertRatingSuccess) {
          showAppSnackBar(context, state.message);
          // Optionally, close the screen or reset the form
          Navigator.pop(context);
        } else if (state is InsertRatingError) {
          showAppSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        final isLoading = state is InsertRatingLoading;

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
                    'Overall rating',
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
                'Tap to rate',
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
                      text: isLoading ? "SUBMITTING..." : "SUBMIT PRODUCT REVIEW",
                      backgroundColor: isLoading ? Colors.grey : Colors.blueAccent,
                      textColor: Colors.white,
                      borderColor: isLoading ? Colors.grey : Colors.blueAccent,
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

