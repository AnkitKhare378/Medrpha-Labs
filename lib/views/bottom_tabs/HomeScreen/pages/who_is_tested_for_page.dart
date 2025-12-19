import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Dashboard/widgets/slide_page_route.dart';
import '../widgets/custom_text_field.dart';
import 'add_address_page.dart';
import 'select_address_page.dart';
import 'widgets/add_more_test_button.dart';
import 'widgets/grid_button.dart';

class WhoIsTestedForPage extends StatefulWidget {
  const WhoIsTestedForPage({super.key});

  @override
  State<WhoIsTestedForPage> createState() => _WhoIsTestedForPageState();
}

class _WhoIsTestedForPageState extends State<WhoIsTestedForPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Map<String, String>? selectedAddress;

  String? selectedGender;
  String? selectedRelation;
  DateTime? selectedDate;

  final List<String> genders = ["Male", "Female", "Other"];
  final List<String> relations = ["Self", "Father", "Mother", "Spouse", "Child", "Other"];

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Who is Tested For", style: GoogleFonts.poppins()),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(label: "First Name", controller: firstNameController),
              CustomTextField(label: "Last Name", controller: lastNameController),

              // Date Picker
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    selectedDate == null
                        ? "Select Date"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Gender",
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                ),
                initialValue: selectedGender,
                items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) => setState(() => selectedGender = val),
              ),
              const SizedBox(height: 12),

              // Relation Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Relation",
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                ),
                initialValue: selectedRelation,
                items: relations.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (val) => setState(() => selectedRelation = val),
              ),
              const SizedBox(height: 12),

              // Phone
              CustomTextField(
                label: "Phone No.",
                controller: phoneController,
                inputType: TextInputType.phone,
              ),

              SizedBox(height: 10,),

              Text("Pickup Details", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              selectedAddress != null
                                  ? selectedAddress!['address']!
                                  : "Flat No. 3A, Green Meadows Complex,\nThiruvanmiyur Beach Road,\nChennai – 600041",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AddMoreTestButton(
                      title: "ADD NEW ADDRESS",
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          SlidePageRoute(page: const AddAddressPage()),
                        );

                        if (result != null && mounted) {
                          // Build a displayable address string
                          final combinedAddress =
                              '${result['flat']}, ${result['street']},\n${result['locality']} – ${result['pincode']}';

                          setState(() {
                            selectedAddress = {
                              'title': result['title'] ?? 'New Address',
                              'address': combinedAddress,
                            };
                          });

                          print('New Address Added: $selectedAddress');
                        }
                      }, textColor: Colors.black87,
                    ),
                    SizedBox(height: 10,),
                    AddMoreTestButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          SlidePageRoute(page: const SelectAddressPage()),
                        );

                        if (result != null && mounted) {
                          // result is Map<String,String> from SelectAddressPage
                          setState(() => selectedAddress = Map<String, String>.from(result));
                        }
                      },
                      title: "SELECT ADDRESS",
                      backgroundColor: Colors.blueAccent, textColor: Colors.white,borderColor: Colors.blueAccent,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.delivery_dining, size: 30,),
                        SizedBox(width: 10,),
                        Text("Pickup by, 01:30PM, Today ", style: GoogleFonts.poppins(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GridButton(
                        text: "PROCEED TO PAYMENT",
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   SlidePageRoute(
                          //     page: WhoIsTestedForPage(),
                          //   ),
                          // );
                        },
                        borderColor: Colors.blueAccent),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
