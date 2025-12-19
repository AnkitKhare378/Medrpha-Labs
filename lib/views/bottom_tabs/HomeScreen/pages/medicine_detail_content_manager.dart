// medicine_detail_content_manager.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/widgets/test_detail_shimmer.dart';
import '../../../../view_model/MedicineVM/medicine_detail_view_model.dart';
import 'medicine_detail_content_and_ratings.dart';

class MedicineDetailContentManager extends StatelessWidget {
  const MedicineDetailContentManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineDetailCubit, MedicineDetailState>(
      builder: (context, state) {
        if (state is MedicineDetailLoading) {
          // You will need to create the MedicineDetailShimmer widget
          return const TestDetailShimmer();
        }

        if (state is MedicineDetailError) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                "Error: ${state.message}",
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          );
        }

        if (state is MedicineDetailLoaded) {
          return MedicineDetailContentAndRatings(detail: state.medicineDetail);
        }

        return const SizedBox.shrink();
      },
    );
  }
}