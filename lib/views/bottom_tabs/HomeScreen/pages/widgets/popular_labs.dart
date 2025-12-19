import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../lab_view_page.dart';

class PopularLabs extends StatefulWidget {
  const PopularLabs({super.key});

  @override
  State<PopularLabs> createState() => _PopularLabsState();
}

class _PopularLabsState extends State<PopularLabs> {
  String selectedCategory = 'Popular';


  final List<String> categories = [
    'Popular',
    'Nearby',
    'Top Rated',
    'Affordable',
  ];

  final List<Map<String, dynamic>> labs = [
    {
      "name": "TrueTest Pathology",
      "distance": "2.3 km away",
      "turnaround": "12 hours",
      "rating": "4.6 (1,240 reviews)",
      "price": "₹499/- only",
      "category": "Popular"
    },
    {
      "name": "Nova Check Labs",
      "distance": "4.1 km away",
      "turnaround": "14 hours",
      "rating": "4.3 (830 reviews)",
      "price": "₹550/- only",
      "category": "Popular"
    },
    {
      "name": "BioSure Diagnostics",
      "distance": "1.8 km away",
      "turnaround": "6–8 hours",
      "rating": "4.8 (2,110 reviews)",
      "price": "₹469/- only",
      "category": "Top Rated"
    },
    {
      "name": "Apollo Diagnostics",
      "distance": "2.5 km",
      "turnaround": "24 hrs",
      "rating": "4.5 (980 reviews)",
      "price": "₹500/- only",
      "category": "Nearby"
    },
    {
      "name": "Dr. Lal PathLabs",
      "distance": "3.0 km",
      "turnaround": "12 hrs",
      "rating": "4.7 (1,540 reviews)",
      "price": "₹650/- only",
      "category": "Popular"
    },
    {
      "name": "City Care Labs",
      "distance": "1.2 km",
      "turnaround": "10 hrs",
      "rating": "4.2 (600 reviews)",
      "price": "₹400/- only",
      "category": "Nearby"
    },
    {
      "name": "Shree Labs",
      "distance": "1.9 km",
      "turnaround": "8 hrs",
      "rating": "4.1 (480 reviews)",
      "price": "₹350/- only",
      "category": "Affordable"
    },
    {
      "name": "Thyrocare",
      "distance": "5.0 km",
      "turnaround": "24 hrs",
      "rating": "4.8 (2,500 reviews)",
      "price": "₹600/- only",
      "category": "Top Rated"
    },
    {
      "name": "QuickTest Labs",
      "distance": "2.7 km",
      "turnaround": "6 hrs",
      "rating": "4.0 (700 reviews)",
      "price": "₹299/- only",
      "category": "Affordable"
    },
  ];


  final Map<String, List<Map<String, String>>> labsData = {
    'Popular': [
      {
        'name': 'Apollo Diagnostics',
        'rating': '4.5 ★',
        'address': 'MG Road, Indore',
        'offer': 'Up to 20% OFF'
      },
      {
        'name': 'Dr. Lal PathLabs',
        'rating': '4.7 ★',
        'address': 'Vijay Nagar, Indore',
        'offer': 'Free Home Sample'
      },
    ],
    'Nearby': [
      {
        'name': 'City Care Labs',
        'rating': '4.2 ★',
        'address': 'Palasia, Indore',
        'offer': 'Flat ₹100 OFF'
      },
      {
        'name': 'Shree Labs',
        'rating': '4.1 ★',
        'address': 'Rajendra Nagar',
        'offer': '10% Cashback'
      },
    ],
    'Top Rated': [
      {
        'name': 'Thyrocare',
        'rating': '4.8 ★',
        'address': 'Bhawarkuan, Indore',
        'offer': 'Up to 25% OFF'
      },
    ],
    'Affordable': [
      {
        'name': 'QuickTest Labs',
        'rating': '4.0 ★',
        'address': 'Sapna Sangeeta',
        'offer': 'Tests starting ₹99'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> currentLabs =
    labs.where((lab) => lab['category'] == selectedCategory).toList(); // ✅ Use new labs

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double cardWidth = screenWidth * 0.43;
    final double cardHeight = screenHeight * 0.28;
    final double bookNowHeight = screenHeight * 0.05;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Labs',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),

        // Category Chips (you can still keep them, but currently they don't filter labs)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final isSelected = category == selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    category,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.blueAccent,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                      // TODO: if you want filtering, implement switch-case to filter labs
                    });
                  },
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.blueAccent),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 15),

        // Horizontal Scrollable Labs
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: currentLabs.length,
            itemBuilder: (context, index) {
              final lab = currentLabs[index];
              return Container(
                width: cardWidth,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lab['name'] ?? "N/A",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lab['rating'] ?? "N/A",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lab['distance'] ?? "N/A",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "TAT: ${lab['turnaround'] ?? 'N/A'}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lab['price'] ?? "N/A",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: bookNowHeight,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LabViewPage(
                                lab: lab,
                                labName: lab['name'] ?? "",
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'View Lab',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}
