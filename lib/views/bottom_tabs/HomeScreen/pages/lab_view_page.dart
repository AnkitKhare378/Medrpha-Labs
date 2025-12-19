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

class LabViewPage extends StatefulWidget {
  final Map<String, dynamic> lab;
  final String labName;

  const LabViewPage({super.key, required this.lab, required this.labName});

  @override
  State<LabViewPage> createState() => _LabViewPageState();
}

class _LabViewPageState extends State<LabViewPage> {
  // 🔹 Static (always present) tests
  final List<Map<String, dynamic>> staticTests = [
    {"name": "Blood Sugar", "price": 200},
  ];

  // 🔹 Dynamic (user-selected) tests
  List<Map<String, dynamic>> dynamicTests = [];

  Map<String, String>? selectedAddress;

  List<Map<String, dynamic>> get allTests => [...staticTests, ...dynamicTests];

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
    final int totalPrice =
    allTests.fold(0, (sum, test) => sum + (test["price"] as int));

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

            // 🔹 My Test List
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My Test List",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),

                  // List of tests
                  ...allTests.map((test) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(test["name"],
                              style: GoogleFonts.poppins(fontSize: 14)),
                          Text("₹${test["price"]}",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),
                    );
                  }),

                  const Divider(thickness: 0.8, height: 20),

                  // Total Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      Text("₹$totalPrice",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffd63031))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ADD MORE TEST Button
                  AddMoreTestButton(
                    title: '+ ADD MORE TEST',
                    backgroundColor: Colors.grey.shade300,
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        SlidePageRoute(
                          page: const AddMoreTestsPage(),
                        ),
                      );

                      if (result != null &&
                          result is List<Map<String, dynamic>>) {
                        setState(() {
                          for (var test in result) {
                            if (!dynamicTests
                                .any((t) => t["name"] == test["name"])) {
                              dynamicTests.add(test);
                            }
                          }
                        });
                      }
                    },
                    textColor: Colors.black87,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Address selection area
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pickup Location",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, fontWeight: FontWeight.w600)),
                              Text(
                                displayAddress,
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // 🟢 EDIT ICON
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          final addressToEdit =
                              selectedAddress ?? defaultAddress;

                          // 🟢 Navigate with current address values
                          final result = await Navigator.of(context).push(
                            SlidePageRoute(
                              page: AddAddressPage(
                                existingAddress: {
                                  'title': addressToEdit['title'] ?? '',
                                  'flat': addressToEdit['flat'] ?? '',
                                  'street': addressToEdit['street'] ?? '',
                                  'locality': addressToEdit['locality'] ?? '',
                                  'pincode': addressToEdit['pincode'] ?? '',
                                },
                              ),
                            ),
                          );

                          if (result != null && mounted) {
                            final formatted = formatAddress(result);
                            setState(() {
                              selectedAddress = {
                                'title': result['title'] ?? 'Updated Address',
                                'flat': result['flat'] ?? '',
                                'street': result['street'] ?? '',
                                'locality': result['locality'] ?? '',
                                'pincode': result['pincode'] ?? '',
                                'address': formatted,
                              };
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 🟢 ADD NEW ADDRESS
                  AddMoreTestButton(
                    title: "ADD NEW ADDRESS",
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        SlidePageRoute(page: const AddAddressPage()),
                      );

                      if (result != null && mounted) {
                        final formatted = formatAddress({
                          'flat': result['flat'] ?? '',
                          'street': result['street'] ?? '',
                          'locality': result['locality'] ?? '',
                          'pincode': result['pincode'] ?? '',
                        });

                        setState(() {
                          selectedAddress = {
                            'title': result['title'] ?? 'New Address',
                            'address': formatted,
                          };
                        });
                      }
                    },
                    textColor: Colors.black87,
                  ),

                  const SizedBox(height: 10),

                  // 🟢 SELECT ADDRESS
                  AddMoreTestButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        SlidePageRoute(page: const SelectAddressPage()),
                      );

                      if (result != null && mounted) {
                        setState(() =>
                        selectedAddress = Map<String, String>.from(result));
                      }
                    },
                    title: "SELECT ADDRESS",
                    backgroundColor: Colors.blueAccent,
                    textColor: Colors.white,
                    borderColor: Colors.blueAccent,
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.delivery_dining, size: 30),
                      const SizedBox(width: 10),
                      Text("Pickup by, 01:30PM, Today ",
                          style: GoogleFonts.poppins(fontSize: 14)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Lab Address Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Address",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(widget.lab["name"],
                          style:
                          GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(
                          "No. 47, Green Valley Main Road,\nNear City Metro Station,\nAnna Nagar, Chennai – 600040",
                          style: GoogleFonts.poppins(fontSize: 14)),
                      const SizedBox(height: 8),
                      Text("+91 98765 43210", style: GoogleFonts.poppins()),
                    ],
                  ),
                ],
              ),
            ),

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
