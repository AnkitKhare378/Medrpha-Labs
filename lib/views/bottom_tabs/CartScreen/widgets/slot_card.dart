import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SlotCard extends StatefulWidget {
  const SlotCard({super.key});

  @override
  State<SlotCard> createState() => _SlotCardState();
}

class _SlotCardState extends State<SlotCard> {
  // Define slots in 24-hour format internally for easy comparison
  final List<String> rawTimeSlots = const [
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
  ];

  late String _selectedSlot;
  DateTime _selectedDate = DateTime.now();
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _updateInitialSlot();
  }

  // Logic to filter slots based on selected date and current time
  List<String> get _filteredSlots {
    final now = DateTime.now();
    bool isToday = _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;

    if (!isToday) return rawTimeSlots;

    // Filter slots: only show if slot hour is greater than current hour
    return rawTimeSlots.where((slot) {
      int slotHour = int.parse(slot.split(':')[0]);
      return slotHour > now.hour;
    }).toList();
  }

  void _updateInitialSlot() {
    final available = _filteredSlots;
    _selectedSlot = available.isNotEmpty ? available.first : "No slots";
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateInitialSlot(); // Reset slot when date changes
      });
    }
  }

  String _formatTo12Hr(String slot24) {
    if (slot24 == "No slots") return slot24;
    final hr = int.parse(slot24.split(':')[0]);
    final period = hr >= 12 ? "PM" : "AM";
    final displayHr = hr > 12 ? hr - 12 : (hr == 0 ? 12 : hr);
    return "${displayHr.toString().padLeft(2, '0')}:00 $period";
  }

  @override
  Widget build(BuildContext context) {
    final availableSlots = _filteredSlots;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            // Date Selection Tile
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.blueAccent, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('EEE, dd MMM yyyy').format(_selectedDate),
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    const Icon(Icons.edit, size: 16, color: Colors.blueAccent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Header Row
            Row(
              children: [
                const Icon(Icons.access_time_filled, color: Colors.orange, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _isExpanded ? 'Available Slots' : 'Selected: ${_formatTo12Hr(_selectedSlot)}',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  color: Colors.blueAccent,
                )
              ],
            ),

            if (_isExpanded) ...[
              const SizedBox(height: 10),
              if (availableSlots.isEmpty)
                Text(
                  "No time slots available for today.",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.redAccent),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: availableSlots.map((slot) {
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

  Widget _buildSlotButton(String slot, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedSlot = slot),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
            width: 1.5,
          ),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: Text(
          _formatTo12Hr(slot),
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.blueAccent : Colors.black54,
          ),
        ),
      ),
    );
  }
}