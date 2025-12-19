import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> reports = [
      {
        'title': 'Full Body Checkup',
        'date': '10 Sep 2025',
        'status': 'Completed',
        'downloaded': 'Yes',
      },
      {
        'title': 'Thyroid Test',
        'date': '01 Sep 2025',
        'status': 'Pending',
        'downloaded': 'No',
      },
      {
        'title': 'Vitamin D Test',
        'date': '25 Aug 2025',
        'status': 'Completed',
        'downloaded': 'Yes',
      },
      {
        'title': 'Diabetes Check',
        'date': '20 Aug 2025',
        'status': 'Completed',
        'downloaded': 'No',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Reports',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: reports.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final report = reports[index];

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        report['title']!,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        report['date']!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Status and Download
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                          const SizedBox(width: 6),
                          Text(
                            "Status: ${report['status']}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      if (report['downloaded'] == 'Yes')
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Add download/view logic
                          },
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text("Download"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.poppins(fontSize: 13),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      if (report['downloaded'] == 'No')
                        Text(
                          "Report not available",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
