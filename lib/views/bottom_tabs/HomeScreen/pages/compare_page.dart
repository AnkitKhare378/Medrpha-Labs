import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComparePage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedLabs;

  const ComparePage({super.key, required this.selectedLabs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Compare Labs",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: selectedLabs.length < 2
          ? Center(
        child: Text(
          "Select at least 2 labs to compare",
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            _buildRow("", (lab) => Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image,
                  size: 40, color: Colors.grey),
            )),
            _buildDivider(),
            _buildRow("Name", (lab) => Text(lab["name"])),
            _buildDivider(),
            _buildRow("Distance", (lab) => Text(lab["distance"])),
            _buildDivider(),
            _buildRow("Turnaround", (lab) => Text(lab["turnaround"])),
            _buildDivider(),
            _buildRow("Rating", (lab) => Text(lab["rating"])),
            _buildDivider(),
            _buildRow("Cost", (lab) => Text(lab["price"])),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
      String parameter, Widget Function(Map<String, dynamic>) valueBuilder) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Parameter Title
          SizedBox(
            width: 100,
            child: Text(
              parameter,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 🔹 Values for each lab
          Row(
            children: selectedLabs.map((lab) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                alignment: Alignment.center,
                child: valueBuilder(lab),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Divider(
      color: Colors.grey.shade300,
      thickness: 0.8,
      height: 0,
    ),
  );
}
