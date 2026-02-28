// lib/views/.../order_filter_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/OrderM/order_history.dart';

class OrderFilterSheet extends StatefulWidget {
  final OrderFilters initialFilters;
  const OrderFilterSheet({super.key, required this.initialFilters});

  @override
  State<OrderFilterSheet> createState() => _OrderFilterSheetState();
}

class _OrderFilterSheetState extends State<OrderFilterSheet> {
  late OrderFilters _tempFilters;

  @override
  void initState() {
    super.initState();
    // Create a copy so changes aren't permanent until 'Apply' is pressed
    _tempFilters = OrderFilters(
      status: widget.initialFilters.status,
      timeRange: widget.initialFilters.timeRange,
    );
  }

  Widget _buildChip(String label, String? groupValue, Function(String?) onSelected) {
    bool isSelected = groupValue == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        onSelected(selected ? label : null); // Toggle selection
      },
      selectedColor: Colors.orange.shade100,
      backgroundColor: Colors.white,
      labelStyle: GoogleFonts.poppins(
        color: isSelected ? Colors.orange.shade900 : Colors.black87,
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? Colors.orange : Colors.grey.shade300),
      ),
      showCheckmark: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Filters", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              )
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          Text("Order Status", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: ["Ordered", "Scheduled", "On the way", "Delivered", "Cancelled"].map((s) {
              return _buildChip(s, _tempFilters.status, (val) => setState(() => _tempFilters.status = val));
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text("Order Time", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: ["Last 30 days", "2024", "2023", "Older"].map((t) {
              return _buildChip(t, _tempFilters.timeRange, (val) => setState(() => _tempFilters.timeRange = val));
            }).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() => _tempFilters.clear());
                  },
                  child: Text("Clear All", style: GoogleFonts.poppins(color: Colors.redAccent)),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _tempFilters),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text("Apply Filters", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}