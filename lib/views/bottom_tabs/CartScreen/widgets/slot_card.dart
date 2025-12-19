import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlotCard extends StatefulWidget {
  const SlotCard({super.key});

  @override
  State<SlotCard> createState() => _SlotCardState();
}

class _SlotCardState extends State<SlotCard> {
  final List<String> timeSlots = const [
    '10:00',
    '11:00',
    '12:00',
    '01:00',
  ];

  late String _selectedSlot;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _selectedSlot = timeSlots.first;
  }

  Widget _buildSlotButton(String slot, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Only allow selection if the slots are expanded
        if (_isExpanded) {
          setState(() {
            _selectedSlot = slot;
            print('Selected slot updated to: $_selectedSlot');
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.blue.shade100,
            width: 1.5,
          ),
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        ),
        child: Text(
          slot,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.blueAccent : Colors.blue.shade100,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time_filled,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _isExpanded
                        ? 'Available Time Slots'
                        : 'Selected Slot: $_selectedSlot',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0, // Rotate 180 degrees when expanded
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.blueAccent,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: timeSlots.map((slot) {
                  final isSelected = slot == _selectedSlot;
                  return _buildSlotButton(slot, isSelected);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}