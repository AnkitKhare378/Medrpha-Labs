import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/LabM/lab_model.dart';
import '../../../../view_model/LabVM/AllLab/lab_bloc.dart';
import '../../../../view_model/LabVM/AllLab/lab_event.dart';
import '../../../../view_model/LabVM/AllLab/lab_state.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../TestScreen/lab_test_list_page.dart';
import '../widgets/lab_shimmer_loading.dart';
import 'company_medicine_view.dart';

class AllLabMedicinePage extends StatefulWidget {
  final String labName;
  const AllLabMedicinePage({required this.labName, super.key});

  @override
  State<AllLabMedicinePage> createState() => _AllLabMedicinePageState();
}

class _AllLabMedicinePageState extends State<AllLabMedicinePage> {
  static const String _imageBaseUrl = 'https://www.online-tech.in/LabImage/';
  List<LabModel> selectedLabs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LabBloc>().add(FetchLabsEvent());
    });
  }

  // Toggle function now accepts LabModel
  void toggleCompare(LabModel lab) {
    setState(() {
      if (selectedLabs.contains(lab)) {
        selectedLabs.remove(lab);
      } else if (selectedLabs.length < 5) {
        selectedLabs.add(lab);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You can only select up to 5 labs for comparison."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.labName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<LabBloc, LabState>(
        builder: (context, state) {
          if (state is LabLoading) {
            return const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: LabShimmerLoading(),
            );
          }
          if (state is LabError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to load labs: ${state.message}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LabBloc>().add(FetchLabsEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is LabLoaded) {
            final labs = state.labs;

            if (labs.isEmpty) {
              return Center(
                child: Text('No labs found for your criteria.', style: GoogleFonts.poppins()),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔹 Labs List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: labs.length,
                    itemBuilder: (context, index) {
                      final lab = labs[index];
                      final isSelected = selectedLabs.contains(lab);

                      // Construct the full image URL
                      final imageUrl = lab.labImage != null && lab.labImage!.isNotEmpty
                          ? '$_imageBaseUrl${lab.labImage}'
                          : null;

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(SlidePageRoute(page: CompanyMedicineView(companyId: lab.companyId ?? 0, companyName: lab.company ?? "")),);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🖼️ Image Container Updated
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
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
                                          child: Icon(Icons.business, size: 40, color: Colors.grey));
                                    },
                                  )
                                      : const Center(
                                      child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
                                ),
                              ),
                              // ------------------------------------
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lab.labName, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                                    Text(lab.description ?? "", style: GoogleFonts.poppins(fontSize: 12,)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: LabShimmerLoading(),
          );
        },
      ),
    );
  }
}