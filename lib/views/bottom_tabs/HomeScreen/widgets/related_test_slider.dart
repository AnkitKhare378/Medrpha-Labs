import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import 'package:medrpha_labs/config/color/colors.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/lab_test_detail_page.dart';
import '../../../../data/repositories/synonym_service/test_synonyms_service.dart';
import '../../../../models/SynonymsM/test_synonyms_model.dart';
import '../../../../view_model/SynonymsVM/test_synonym_view_model.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';

class RelatedTestCard extends StatelessWidget {
  final TestSynonymModel test;

  const RelatedTestCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    // The parent ListView/SizedBox sets a height constraint of 180 pixels.
    // The sum of all children's heights + padding must be less than 180.
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100)
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: 60,
                width: 60,
                child: Image.network(
                  "${ApiConstants.testImageBaseUrl}${test.testImage ?? ''}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Iconsax.image, size: 30, color: Colors.grey),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: Icon(Icons.downloading, size: 30, color: Colors.grey));
                  },
                ),
              ),
            ),

            const SizedBox(height: 6), // Reduced spacing (from 10 to 6)

            // 2. Test Name (maxLines: 2) -> ~35-40px
            Text(
              test.synonymName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4), // Reduced spacing

            // 3. Lab Name (maxLines: 1) -> ~18px
            Text(
              test.categoryName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  test.testCode,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "₹${test.testPrice.toStringAsFixed(0)}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RelatedTestsSlider extends StatelessWidget {
  final int testId;

  const RelatedTestsSlider({super.key, required this.testId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TestSynonymBloc>(
      create: (context) => TestSynonymBloc(TestSynonymsService())
        ..add(FetchTestSynonyms(testId)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Text(
              "Related Synonyms & Items",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          // BLoC Builder to handle loading and data states
          BlocBuilder<TestSynonymBloc, TestSynonymState>(
            builder: (context, state) {
              if (state is TestSynonymLoading) {
                // Return a simple loading placeholder for the slider area
                return _buildShimmerSlider();
              }

              if (state is TestSynonymError) {
                // Show error message
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Failed to load related items: ${state.message}"),
                );
              }

              if (state is TestSynonymLoaded) {
                if (state.synonyms.isEmpty) {

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "No related items found",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }

                // Horizontal ListView
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      SlidePageRoute(page: LabTestDetailPage(testId: testId)),
                    );
                  },
                  child: SizedBox(
                    height: 200, // Set a fixed height for the slider content
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.synonyms.length,
                      itemBuilder: (context, index) {
                        return RelatedTestCard(test: state.synonyms[index]);
                      },
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Simple placeholder for the loading state of the slider
  Widget _buildShimmerSlider() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3, // Show 3 shimmer cards
        itemBuilder: (context, index) {
          // You can replace this with a proper shimmer effect if available
          return Container(
            width: 200,
            height: 180,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}