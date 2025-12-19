import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/add_address_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/add_more_test_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/who_is_tested_for_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/grid_button.dart';
import '../../../../config/color/colors.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import 'select_address_page.dart';
import 'widgets/add_more_test_button.dart';
import 'widgets/info_row.dart';

class LabDetailPage extends StatefulWidget {
  final Map<String, dynamic> lab;
  final String labName;

  const LabDetailPage({super.key, required this.lab, required this.labName});

  @override
  State<LabDetailPage> createState() => _LabDetailPageState();
}

class _LabDetailPageState extends State<LabDetailPage> {

  // 🔹 Dynamic (user-selected) tests
  List<Map<String, dynamic>> dynamicTests = [];

  Map<String, String>? selectedAddress;

  /// ✅ Format address into multi-line string (break after 2nd comma)
  String formatAddress(Map<String, String> address) {
    final flat = address['flat'] ?? '';
    final street = address['street'] ?? '';
    final locality = address['locality'] ?? '';
    final pincode = address['pincode'] ?? '';

    // 🔹 Split street by commas and insert line breaks
    final parts = street.split(',');
    String formattedStreet = '';
    for (int i = 0; i < parts.length; i++) {
      formattedStreet += parts[i].trim();
      if (i < parts.length - 1) {
        formattedStreet += ',\n'; // newline after each comma
      }
    }

    // 🔹 Return formatted multiline address
    return '$flat\n$formattedStreet\n$locality – $pincode';
  }

  @override
  Widget build(BuildContext context) {

    // ✅ Default address (if user hasn’t selected one)
    final defaultAddress = {
      'title': 'Home',
      'flat': 'Flat No. 3A',
      'street': 'Green Meadows Complex, Thiruvanmiyur Beach Road',
      'locality': 'Chennai',
      'pincode': '600041',
    };

    final displayAddress = selectedAddress != null
        ? selectedAddress!['address']!
        : formatAddress(defaultAddress);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.lab["name"],
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image Banner
            Center(
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Lab Information
            Text("Lab Information",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            InfoRow(title: "Name", value: widget.lab["name"]),
            _divider(),
            InfoRow(title: "Distance", value: widget.lab["distance"]),
            _divider(),
            InfoRow(title: "Turnaround", value: widget.lab["turnaround"]),
            _divider(),
            InfoRow(title: "Rating", value: widget.lab["rating"]),
            _divider(),
            InfoRow(title: "Cost", value: "${widget.lab["price"]}"),
            const SizedBox(height: 24),

            // 🔹 Contact & Address
            Text("Contact Details",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            InfoRow(title: "Phone", value: widget.lab["phone"] ?? "N/A"),
            _divider(),
            InfoRow(
                title: "Address",
                value: widget.lab["address"] ?? "Not available"),

            const SizedBox(height: 24),

            // 🔹 Action Buttons
            Row(
              children: [
                Expanded(
                  child: GridButton(
                    text: "PROCEED TO BOOKING",
                    backgroundColor: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: WhoIsTestedForPage(),
                        ),
                      );
                    },
                    borderColor: Colors.blueAccent,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _divider() => Divider(
    color: Colors.grey.shade300,
    thickness: 0.6,
    height: 0,
  );
}
