import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LabsListDialog extends StatelessWidget {
  final List<Map<String, String>> labs;

  const LabsListDialog({super.key, required this.labs});

  Future<void> _saveSelectedLab(Map<String, String> lab) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLabName', lab['name']!);
    await prefs.setString('selectedLabLocation', lab['location']!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Available Labs",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: labs.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final lab = labs[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: const Icon(Icons.local_hospital,
                          color: Colors.blueAccent),
                    ),
                    title: Text(
                      lab['name']!,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      lab['location']!,
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Colors.grey.shade500, size: 16),
                    onTap: () async {
                      await _saveSelectedLab(lab);
                      Navigator.pop(context, lab); // also return lab
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
