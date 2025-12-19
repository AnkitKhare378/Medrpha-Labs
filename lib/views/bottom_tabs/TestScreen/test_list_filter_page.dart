import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/grid_button.dart';
import '../../../view_model/LabVM/AllSymptoms/symptom_bloc.dart';
import '../../../view_model/LabVM/AllSymptoms/symptom_event.dart';
import '../../../view_model/LabVM/AllSymptoms/symptom_state.dart';
import '../HomeScreen/pages/widgets/filter_app_bar.dart';

class TestFilterPage extends StatefulWidget {
  final int initialSymptomId;
  final Function(int) onApplyFilter;

  const TestFilterPage({
    super.key,
    required this.initialSymptomId,
    required this.onApplyFilter,
  });

  @override
  State<TestFilterPage> createState() => _TestFilterPageState();
}

class _TestFilterPageState extends State<TestFilterPage> {
  int selectedIndex = 0;
  String selectedSort = "Popularity";
  int _selectedSymptomId = 0;

  final List<String> filterCategories = [
    "Sort by (1)",
    "Symptoms",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SymptomBloc>().add(FetchSymptomsEvent());
    });
    _selectedSymptomId = widget.initialSymptomId;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FilterAppBar(title: "Filters (1)"),
      body: Row(
        children: [
          // Left Menu
          Container(
            width: 120,
            color: Colors.grey.shade200,
            child: ListView.builder(
              itemCount: filterCategories.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    color: isSelected ? Colors.white : Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
                    child: Text(
                      filterCategories[index],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: _buildRightContent(),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: GridButton(
                text: "CLEAR FILTERS",
                backgroundColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.grey,
                onPressed: () {
                  setState(() {
                    selectedSort = "Popularity";
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GridButton(text: 'APPLY FILTER', backgroundColor: Colors.blueAccent, textColor: Colors.white,
                  onPressed: () {
                    // Print before popping (optional, for debugging)
                    print("Selected Symptom ID: $_selectedSymptomId");

                    Navigator.of(context).pop(_selectedSymptomId);
                  },borderColor: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightContent() {
    // Sort by (1)
    if (selectedIndex == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sort by", style: GoogleFonts.poppins(fontSize: 14)),
          const SizedBox(height: 10),
          _buildRadio("Popularity"),
          _buildRadio("High to Low"),
          _buildRadio("Low to High"),
        ],
      );
    }

    // Symptoms (2)
    if (selectedIndex == 1) {
      return BlocBuilder<SymptomBloc, SymptomState>(
        builder: (context, state) {
          if (state is SymptomLoading || state is SymptomInitial) {
            return _buildSymptomShimmer(); // Show shimmer (assuming this is defined elsewhere)
          }
          if (state is SymptomError) {
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
            final List<dynamic> symptoms = state.symptoms; // Assuming the symptoms list is dynamic or a specific Symptom model

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

            // **This is the main list view for the Symptoms**
            return ListView.builder(
              itemCount: symptoms.length,
              itemBuilder: (context, index) {
                final symptom = symptoms[index];

                // Adjust based on your model fields
                final int symptomId = symptom.id ?? 0;
                final String symptomName = symptom.name ?? 'Symptom $index';

                return CheckboxListTile(
                  title: Text(
                    symptomName,
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  value: _selectedSymptomId == symptomId, // ✅ mark as selected if IDs match
                  onChanged: (bool? newValue) {
                    setState(() {
                      if (newValue == true) {
                        _selectedSymptomId = symptomId; // ✅ store selected ID
                      } else {
                        _selectedSymptomId = 0; // deselect
                      }
                    });

                    // Optional for debug
                    print("Selected Symptom: $symptomName (ID: $_selectedSymptomId)");
                  },
                  activeColor: Colors.blueAccent,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            );
          }

          // Default case, should ideally not be reached if initial state is handled
          return const Center(child: Text('Unknown State'));
        },
      );
    }

    // Fallback for other indices (if added later)
    return Center(
      child: Text(
        "Options for ${filterCategories[selectedIndex]}",
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  Widget _buildSymptomShimmer() {
    return const Center(child: CircularProgressIndicator()); // Replace with your actual shimmer widget
  }

  Widget _buildRadio(String value) {
    return RadioListTile<String>(
      title: Text(value, style: GoogleFonts.poppins(fontSize: 13)),
      value: value,
      groupValue: selectedSort,
      onChanged: (val) {
        setState(() {
          selectedSort = val!;
        });
      },
    );
  }
}
