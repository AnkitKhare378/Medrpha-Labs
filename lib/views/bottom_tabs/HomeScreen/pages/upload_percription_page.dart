// ------------------------------------------------------------------
// 1.2 UploadPrescriptionPage
// ------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/color/colors.dart';

class UploadPrescriptionPage extends StatelessWidget {
  const UploadPrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor, // Aqua/Teal color from screenshot
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Upload prescription',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What is a valid prescription?',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Prescription Image Placeholder
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // This is a simplified static representation of the image details
                  const PrescriptionDetailRow(
                      text: 'Dr Apurva Kumar', label: 'Doctor\'s details', number: 1),
                  const PrescriptionDetailRow(
                      text: '20-01-2025', label: 'Date of prescription', number: 2),
                  const PrescriptionDetailRow(
                      text: 'Megha Raj', label: 'Patient\'s details', number: 3),
                  const PrescriptionDetailRow(
                      text: 'Paracetamol - 50mg', label: 'Medicines', number: 4),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Rules/Supported Files
            Text(
              '• Include details of doctor, patient & date of visit',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            Text(
              '• Supported files: **PNG, JPEG, PDF**',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            Text(
              '• File size limit: **5MB**',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 40),

            // Upload section header
            Text(
              'Upload prescription using',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Upload Options Row (Camera, Gallery, My Files)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UploadOptionButton(
                    icon: Icons.camera_alt_outlined, label: 'Camera'),
                UploadOptionButton(
                    icon: Icons.image_outlined, label: 'Gallery'),
                UploadOptionButton(
                    icon: Icons.description_outlined, label: 'My Files'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for the prescription details
class PrescriptionDetailRow extends StatelessWidget {
  final String text;
  final String label;
  final int number;

  const PrescriptionDetailRow({
    super.key,
    required this.text,
    required this.label,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dashed),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFe91e63), // Pink circle color
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for the upload buttons
class UploadOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const UploadOptionButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, size: 35, color: AppColors.primaryColor),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }
}