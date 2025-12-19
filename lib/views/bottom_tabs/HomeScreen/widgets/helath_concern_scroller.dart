import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/apiConstant/api_constant.dart';
import '../../../../models/LabM/symptom_model.dart';
import '../../../../view_model/LabVM/AllSymptoms/symptom_bloc.dart';
import '../../../../view_model/LabVM/AllSymptoms/symptom_event.dart';
import '../../../../view_model/LabVM/AllSymptoms/symptom_state.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../TestScreen/lab_test_list_page.dart';

class HealthConcernScroller extends StatefulWidget {
  const HealthConcernScroller({super.key});

  @override
  State<HealthConcernScroller> createState() => _HealthConcernScrollerState();
}

class _HealthConcernScrollerState extends State<HealthConcernScroller> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SymptomBloc>().add(FetchSymptomsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> concerns = [
      {
        'label': 'Fever & Flu',
        'icon': Icons.thermostat,
        'color': Colors.orange.shade50,
      },
      {
        'label': 'Diabetes Care',
        'icon': Icons.bloodtype,
        'color': Colors.red.shade50,
      },
      {
        'label': 'Vitamin Levels',
        'icon': Icons.opacity,
        'color': Colors.yellow.shade50,
      },
      {
        'label': 'Heart Health',
        'icon': Icons.favorite,
        'color': Colors.pink.shade50,
      },
      {
        'label': 'Kidney Health',
        'icon': Icons.water_drop,
        'color': Colors.blue.shade50,
      },
      {
        'label': 'Liver Care',
        'icon': Icons.local_drink,
        'color': Colors.green.shade50,
      },
      {
        'label': 'Thyroid Care',
        'icon': Icons.account_tree,
        'color': Colors.purple.shade50,
      },
      {
        'label': 'Pregnancy',
        'icon': Icons.pregnant_woman,
        'color': Colors.teal.shade50,
      },
      {
        'label': 'Immunity Test',
        'icon': Icons.security,
        'color': Colors.cyan.shade50,
      },
      {
        'label': 'Hormone Test',
        'icon': Icons.science,
        'color': Colors.indigo.shade50,
      },
      {
        'label': 'Allergies',
        'icon': Icons.grass,
        'color': Colors.lightGreen.shade50,
      },
      {
        'label': 'Cancer Care',
        'icon': Icons.healing,
        'color': Colors.deepOrange.shade50,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Test by health concerns",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10,),
        BlocBuilder<SymptomBloc, SymptomState>(
          builder: (context, state) {
            if (state is SymptomLoading || state is SymptomInitial) {
              return _buildSymptomShimmer(); // Show shimmer
            }
            if (state is SymptomError) {
              // Display simple message
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Failed to load symptoms.',
                    style: GoogleFonts.poppins(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (state is SymptomLoaded) {
              final symptoms = state.symptoms;

              if (symptoms.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'No symptoms data available.',
                      style: GoogleFonts.poppins(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: symptoms.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return _buildSymptomItem(symptoms[index]);
                  },
                ),
              );
            }
            // Fallback for initial state before dispatch
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildSymptomShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 6, // Show a few placeholders
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSymptomItem(SymptomModel symptom) {
    const imageBaseUrl = ApiConstants.symptomImageBaseUrl;
    final imageUrl = symptom.symptomsImage != null && symptom.symptomsImage!.isNotEmpty
        ? '$imageBaseUrl${symptom.symptomsImage}'
        : null;

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(SlidePageRoute(page: LabTestListPage(symptomId: symptom.id, labName: "Symptom",)),);
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                          child: Icon(Icons.medication_outlined, size: 30, color: Colors.blueAccent));
                    },
                  )
                      : const Center(
                      child: Icon(Icons.medical_services_outlined, size: 30, color: Colors.blueAccent)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            symptom.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

