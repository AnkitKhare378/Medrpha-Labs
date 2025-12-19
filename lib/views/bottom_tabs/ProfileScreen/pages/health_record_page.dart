import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthRecordPage extends StatelessWidget {
  const HealthRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data – replace with your own records from backend/DB
    final List<Map<String, String>> records = [
      {
        'title': 'Full Body Checkup Report',
        'date': '15 Sep 2025',
        'type': 'Lab Report',
      },
      {
        'title': 'Thyroid Prescription',
        'date': '02 Sep 2025',
        'type': 'Prescription',
      },
      {
        'title': 'Diabetes Report',
        'date': '25 Aug 2025',
        'type': 'Lab Report',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          'Health Records',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Record',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          // TODO: Implement add record action
        },
      ),

      body: records.isEmpty
          ? Center(
        child: Text(
          'No health records found',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final record = records[index];

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon/Badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.3),
                    ),
                  ),
                  child: const Icon(Icons.insert_drive_file,
                      color: Colors.blueAccent, size: 26),
                ),
                const SizedBox(width: 16),

                // Record info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record['title']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            record['date']!,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.category,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            record['type']!,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // View/Download actions
                IconButton(
                  icon: const Icon(Icons.download,
                      color: Colors.blueAccent),
                  onPressed: () {
                    // TODO: download/view file
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
