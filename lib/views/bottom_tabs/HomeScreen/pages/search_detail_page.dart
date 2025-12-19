import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/lab_view_page.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import 'compare_page.dart';
import 'fliter_page.dart';
import 'widgets/grid_button.dart';
import 'widgets/sort_option_sheet.dart';

class LabsPage extends StatefulWidget {
  final String labName;
  const LabsPage({required this.labName, super.key});

  @override
  State<LabsPage> createState() => _LabsPageState();
}

class _LabsPageState extends State<LabsPage> {

  final List<Map<String, dynamic>> labs = [
    {
      "name": "TrueTest Pathology",
      "distance": "2.3 km away",
      "turnaround": "12 hours",
      "rating": "4.6 (1,240 reviews)",
      "price": "₹499/- only",
    },
    {
      "name": "Nova Check Labs",
      "distance": "4.1 km away",
      "turnaround": "14 hours",
      "rating": "4.3 (830 reviews)",
      "price": "₹550/- only",
    },
    {
      "name": "BioSure Diagnostics",
      "distance": "1.8 km away",
      "turnaround": "6–8 hours",
      "rating": "4.8 (2,110 reviews)",
      "price": "₹469/- only",
    },
  ];

  List<Map<String, dynamic>> selectedLabs = [];

  void toggleCompare(Map<String, dynamic> lab) {
    setState(() {
      if (selectedLabs.contains(lab)) {
        selectedLabs.remove(lab);
      } else {
        selectedLabs.add(lab);
      }
    });
  }

  void goToComparePage() {
    if (selectedLabs.length >= 2) {
      Navigator.of(
        context,
      ).push(SlidePageRoute(page: ComparePage(selectedLabs: selectedLabs)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least 2 labs to compare."),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Filters Row
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          builder: (context) {
                            return SortOptionsSheet(
                              onSelected: (option) {
                                setState(() {
                                  if (option == "price_low_high") {
                                    labs.sort(
                                      (a, b) =>
                                          int.parse(
                                            a["price"].replaceAll(
                                              RegExp(r'[^0-9]'),
                                              "",
                                            ),
                                          ) -
                                          int.parse(
                                            b["price"].replaceAll(
                                              RegExp(r'[^0-9]'),
                                              "",
                                            ),
                                          ),
                                    );
                                  } else if (option == "rating_high_low") {
                                    labs.sort(
                                      (a, b) =>
                                          double.parse(
                                            b["rating"].split(" ").first,
                                          ).compareTo(
                                            double.parse(
                                              a["rating"].split(" ").first,
                                            ),
                                          ),
                                    );
                                  } else if (option == "nearest") {
                                    labs.sort(
                                      (a, b) =>
                                          double.parse(
                                            a["distance"].split(" ").first,
                                          ).compareTo(
                                            double.parse(
                                              b["distance"].split(" ").first,
                                            ),
                                          ),
                                    );
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                      child: _buildSortButton(),
                    ),
                  ),
                  Container(height: 40, width: 1, color: Colors.grey.shade400),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).push(SlidePageRoute(page: FilterPage()));
                      },
                      child: _buildFilterButton(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: labs.length,
              itemBuilder: (context, index) {
                final lab = labs[index];
                final isSelected = selectedLabs.contains(lab);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lab["name"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Distance: ${lab["distance"]}",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                Text(
                                  "Turnaround: ${lab["turnaround"]}",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                Text(
                                  "Ratings: ${lab["rating"]}",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Test Cost: ${lab["price"]}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: GridButton(
                              text: isSelected ? "REMOVE" : "COMPARE",
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              borderColor: Colors.grey,
                              onPressed: () => toggleCompare(lab),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GridButton(
                              text: "CHOOSE LAB",
                              borderColor: Colors.blueAccent,
                              backgroundColor: Colors.blueAccent,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).push(
                                  SlidePageRoute(
                                    page: LabViewPage(
                                      lab: lab,
                                      labName: widget.labName,
                                    ),
                                  ),
                                );
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=> LabViewPage(lab: lab, labName: widget.labName,)));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: selectedLabs.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${selectedLabs.length} lab(s) selected",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedLabs.length >= 2
                          ? Colors.blueAccent
                          : Colors.grey, // 🔹 grey when disabled
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: selectedLabs.length >= 2
                        ? goToComparePage
                        : null,
                    child: Text(
                      "Compare",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSortButton() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.swap_vert, size: 18),
        const SizedBox(width: 5),
        Text("Sort by", style: GoogleFonts.poppins(fontSize: 13)),
      ],
    ),
  );

  Widget _buildFilterButton() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.filter_list, size: 18),
        const SizedBox(width: 5),
        Text("Filter", style: GoogleFonts.poppins(fontSize: 13)),
      ],
    ),
  );
}
