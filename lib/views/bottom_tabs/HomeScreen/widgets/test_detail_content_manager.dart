// test_detail_content_manager.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/widgets/test_detail_shimmer.dart'; // Import shimmer
import 'package:medrpha_labs/view_model/TestVM/TestDetail/test_detail_view_model.dart'; // Import BLoC
import 'test_detail_loaded_content.dart'; // Import the loaded content widget

class TestDetailContentManager extends StatelessWidget {
  const TestDetailContentManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestDetailBloc, TestDetailState>(
      builder: (context, state) {
        if (state is TestDetailLoading) {
          return const TestDetailShimmer();
        }

        if (state is TestDetailError) {
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

        if (state is TestDetailLoaded) {
          return TestDetailContentAndRatings(detail: state.testDetail);
        }

        return const SizedBox.shrink();
      },
    );
  }
}