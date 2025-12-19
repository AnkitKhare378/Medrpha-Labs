import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/components/round_button.dart';
import 'view_selected_tests_page.dart';

class AddMoreTestsPage extends StatefulWidget {
  const AddMoreTestsPage({super.key});

  @override
  State<AddMoreTestsPage> createState() => _AddMoreTestsPageState();
}

class _AddMoreTestsPageState extends State<AddMoreTestsPage> {
  final Map<String, List<Map<String, dynamic>>> testCategories = {
    "Blood Tests": [
      {"name": "Complete Blood Count (CBC)", "price": 300, "selected": false},
      {"name": "Hemoglobin (Hb)", "price": 150, "selected": false},
      {"name": "Blood Sugar (Fasting)", "price": 200, "selected": false},
      {"name": "Lipid Profile", "price": 800, "selected": false}
    ],
    "Thyroid & Hormone Tests": [
      {"name": "T3, T4, TSH", "price": 350, "selected": false},
      {"name": "Free T3 (Triiodothyronine)", "price": 350, "selected": false},
      {"name": "Free T4 (FT4)", "price": 450, "selected": false},
      {"name": "Anti-TPO (Thyroid Peroxidase Antibody)", "price": 650, "selected": false}
    ],
    "Fever & Infection Tests": [
      {"name": "Malaria Parasite Test", "price": 300, "selected": false},
      {"name": "Dengue NS1 Antigen", "price": 500, "selected": false},
      {"name": "Typhoid IgM", "price": 450, "selected": false},
      {"name": "C-Reactive Protein (CRP)", "price": 600, "selected": false}
    ],
    "Heart & BP Related Tests": [
      {"name": "ECG (Electrocardiogram)", "price": 400, "selected": false},
      {"name": "Echocardiography", "price": 2000, "selected": false},
      {"name": "Lipid Profile", "price": 800, "selected": false},
      {"name": "Blood Pressure Monitoring", "price": 250, "selected": false}
    ],
    "Kidney & Liver Tests": [],
    "Vitamin & Nutrition Tests": [],
    "Women’s Health": [],
    "Men’s Health": [],
    "Full Body & Wellness Packs": [],
  };

  String searchQuery = "";

  int get selectedCount {
    int count = 0;
    testCategories.forEach((_, tests) {
      count += tests.where((t) => t["selected"] == true).length;
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add More Tests", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 🔹 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search Test",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
            ),
          ),

          // 🔹 Expandable Categories with search applied
          Expanded(
            child: ListView(
              children: testCategories.entries.map((entry) {
                final category = entry.key;
                final tests = entry.value;

                // Filter tests by search query
                final filteredTests = searchQuery.isEmpty
                    ? tests
                    : tests.where((test) =>
                    (test["name"] as String).toLowerCase().contains(searchQuery)).toList();

                if (tests.isEmpty) {
                  return ExpansionTile(
                    title: Text(category, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text("No tests available", style: GoogleFonts.poppins(color: Colors.grey)),
                      )
                    ],
                  );
                }

                // If no test matches search in this category, hide the category
                if (filteredTests.isEmpty) return const SizedBox();

                return ExpansionTile(
                  title: Text(category, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  children: filteredTests.map((test) {
                    return CheckboxListTile(
                      title: Text(test["name"], style: GoogleFonts.poppins(fontSize: 14)),
                      subtitle: Text("Test Cost: ₹${test["price"]}",
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      value: test["selected"],
                      onChanged: (value) {
                        setState(() {
                          test["selected"] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),

          // 🔹 Bottom Buttons
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    // Collect selected tests
                    final selected = <Map<String, dynamic>>[];
                    testCategories.forEach((_, tests) {
                      for (var t in tests) {
                        if (t["selected"] == true) {
                          selected.add({"name": t["name"], "price": t["price"]});
                        }
                      }
                    });

                    // Navigate to ViewSelectedTestsPage
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewSelectedTestsPage(selectedTests: selected),
                      ),
                    );

                    // Update selection after removing
                    if (result != null && result is List<Map<String, dynamic>>) {
                      setState(() {
                        // Clear all selections first
                        testCategories.forEach((_, tests) {
                          for (var t in tests) {
                            t["selected"] =
                                result.any((sel) => sel["name"] == t["name"]);
                          }
                        });
                      });
                    }
                  },

                  child: Text("VIEW SELECTED TESTS (Total:$selectedCount)"),
                ),
                const SizedBox(height: 8),
                RoundButton(
                  title: "PROCEED WITH SELECTED",
                  height: 40,
                  width: double.infinity,
                  onPressed: () {
                    // Collect selected tests
                    final selected = <Map<String, dynamic>>[];
                    testCategories.forEach((_, tests) {
                      for (var t in tests) {
                        if (t["selected"] == true) {
                          selected.add({"name": t["name"], "price": t["price"]});
                        }
                      }
                    });

                    // Return them to LabViewPage
                    Navigator.pop(context, selected);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
