import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

typedef OnDateSelected = void Function(DateTime date);
typedef OnGenderSelected = void Function(String gender);

class BottomSheets {
  static Future<void> showImagePickerDialog({
    required BuildContext context,
    required Future<void> Function(ImageSource source) pickImage,
  }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload a profile picture',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.blueAccent),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Take a photo or upload from your device gallery',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        pickImage(ImageSource.camera);
                      },
                      child: _optionBox(icon: Iconsax.camera, label: 'Camera'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        pickImage(ImageSource.gallery);
                      },
                      child: _optionBox(icon: Iconsax.gallery, label: 'Gallery'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _optionBox({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showGenderPicker({
    required BuildContext context,
    required String selectedGender,
    required OnGenderSelected onGenderSelected,
  }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _bottomSheetContainer(
          context: context,
          title: 'Select Gender',
          child: Column(
            children: ['Male', 'Female', 'Other'].map((gender) {
              final isSelected = selectedGender == gender;
              return GestureDetector(
                onTap: () {
                  onGenderSelected(gender);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2196F3).withOpacity(0.1)
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF2196F3) : Colors.blue.shade100,
                    ),
                  ),
                  child: Text(
                    gender,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF2196F3) : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  static Future<void> showCustomDatePicker({
    required BuildContext context,
    DateTime? selectedDate,
    required OnDateSelected onDateSelected,
  }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _bottomSheetContainer(
          context: context,
          title: 'Select Date of Birth',
          heightFactor: 0.6,
          child: Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: Color(0xFF2196F3)),
              ),
              child: CalendarDatePicker(
                initialDate: selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                onDateChanged: (date) {
                  onDateSelected(date);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _bottomSheetContainer({
    required BuildContext context,
    required String title,
    required Widget child,
    double heightFactor = 0.4,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * heightFactor,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Color(0xFF2196F3)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
