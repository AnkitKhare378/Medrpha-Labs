import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../config/color/colors.dart';
import 'widgets/prescription_detail_row.dart';

class UploadPrescriptionPage extends StatefulWidget {
  const UploadPrescriptionPage({super.key});

  @override
  State<UploadPrescriptionPage> createState() => _UploadPrescriptionPageState();
}

class _UploadPrescriptionPageState extends State<UploadPrescriptionPage> {
  File? _selectedFile;
  bool _isUploading = false; // Track upload state
  final ImagePicker _picker = ImagePicker();

  // Logic for Camera and Gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
        });
        _showSuccessSnackBar("Image selected successfully");
      }
    } catch (e) {
      _showErrorSnackBar("Error picking image: $e");
    }
  }

  // Logic for My Files (PDFs, etc.)
  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.size > 5 * 1024 * 1024) {
          _showErrorSnackBar("File size exceeds 5MB limit");
          return;
        }

        setState(() {
          _selectedFile = File(file.path!);
        });
        _showSuccessSnackBar("Document selected: ${file.name}");
      }
    } catch (e) {
      _showErrorSnackBar("Error picking file: $e");
    }
  }

  // Simulate Upload Function
  Future<void> _uploadData() async {
    if (_selectedFile == null) return;

    setState(() => _isUploading = true);

    try {
      // TODO: Add your API multipart upload logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulating network delay

      _showSuccessSnackBar("Prescription uploaded successfully!");
      setState(() {
        _selectedFile = null; // Clear after success
      });
    } catch (e) {
      _showErrorSnackBar("Upload failed: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Upload prescription',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What is a valid prescription?',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Prescription Preview or Instructions
            _selectedFile != null
                ? _buildFilePreview()
                : _buildStaticInstructions(),

            const SizedBox(height: 25),

            // Upload Button Section (Visible only when file selected)
            if (_selectedFile != null) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _uploadData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('UPLOAD PRESCRIPTION',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],

            Text('• Include details of doctor, patient & date of visit', style: GoogleFonts.poppins(fontSize: 14)),
            Text('• Supported files: PNG, JPEG, PDF', style: GoogleFonts.poppins(fontSize: 14)),
            Text('• File size limit: 5MB', style: GoogleFonts.poppins(fontSize: 14)),

            const SizedBox(height: 40),

            Text(
              'Upload prescription using',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Upload Options Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOption(Icons.camera_alt_outlined, 'Camera', () => _pickImage(ImageSource.camera)),
                _buildOption(Icons.image_outlined, 'Gallery', () => _pickImage(ImageSource.gallery)),
                _buildOption(Icons.description_outlined, 'My Files', _pickDocument),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: _isUploading ? null : onTap, // Disable options while uploading
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, color: AppColors.primaryColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStaticInstructions() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          PrescriptionDetailRow(text: 'Dr Apurva Kumar', label: 'Doctor\'s details', number: 1),
          PrescriptionDetailRow(text: '20-01-2025', label: 'Date of prescription', number: 2),
          PrescriptionDetailRow(text: 'Megha Raj', label: 'Patient\'s details', number: 3),
          PrescriptionDetailRow(text: 'Paracetamol - 50mg', label: 'Medicines', number: 4),
        ],
      ),
    );
  }

  Widget _buildFilePreview() {
    bool isPdf = _selectedFile!.path.toLowerCase().endsWith('.pdf');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          isPdf
              ? const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red)
              : ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(_selectedFile!, height: 200, fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _isUploading ? null : () => setState(() => _selectedFile = null),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text("Remove and try another", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }
}