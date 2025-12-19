import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SortOptionsSheet extends StatelessWidget {
  final void Function(String option) onSelected;

  const SortOptionsSheet({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title + close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sort By",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          // const SizedBox(height: 8),
          // const Divider(),

          ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text("Price: Low to High",
                style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () {
              onSelected("price_low_high");
              Navigator.pop(context);
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.star),
            title: Text("Rating: High to Low",
                style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () {
              onSelected("rating_high_low");
              Navigator.pop(context);
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text("Nearest",
                style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () {
              onSelected("nearest");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
