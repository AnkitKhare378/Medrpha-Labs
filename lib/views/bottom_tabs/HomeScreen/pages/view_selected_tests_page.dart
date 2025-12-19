import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/components/round_button.dart';

class ViewSelectedTestsPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedTests;

  const ViewSelectedTestsPage({super.key, required this.selectedTests});

  @override
  State<ViewSelectedTestsPage> createState() => _ViewSelectedTestsPageState();
}

class _ViewSelectedTestsPageState extends State<ViewSelectedTestsPage> {
  late List<Map<String, dynamic>> currentTests;

  @override
  void initState() {
    super.initState();
    currentTests = List<Map<String, dynamic>>.from(widget.selectedTests);
  }

  int get totalPrice =>
      currentTests.fold(0, (sum, test) => sum + (test["price"] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Selected Tests",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: currentTests.isEmpty
                ? Center(
                child: Text("No tests selected",
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey)))
                : ListView.separated(
              itemCount: currentTests.length,
              separatorBuilder: (_, __) =>
                  Divider(color: Colors.grey.shade300, height: 1),
              itemBuilder: (context, index) {
                final test = currentTests[index];
                return ListTile(
                  title: Text(test["name"],
                      style: GoogleFonts.poppins(fontSize: 14)),
                  subtitle: Text("₹${test["price"]}",
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever_outlined, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        currentTests.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // 🔹 Total + Proceed Button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total:",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    Text("₹$totalPrice",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 8),
                RoundButton(
                  title: "CONFIRM SELECTION",
                  height: 40,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.pop(context, currentTests);
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
