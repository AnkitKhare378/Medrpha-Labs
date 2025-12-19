import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ProfileFormFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String selectedGender;
  final TextEditingController dobController;
  final VoidCallback onGenderTap;
  final VoidCallback onDateTap;

  const ProfileFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.selectedGender,
    required this.dobController,
    required this.onGenderTap,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text Fields
        _FieldLabelAndInput(label: 'First Name*', controller: firstNameController),
        _FieldLabelAndInput(label: 'Last Name*', controller: lastNameController),
        _FieldLabelAndInput(label: 'Mobile Number', controller: phoneController),
        _FieldLabelAndInput(label: 'Email', controller: emailController),

        // Gender Dropdown
        _GenderField(selectedGender: selectedGender, onTap: onGenderTap),

        // Date of Birth Field
        _DateField(dobController: dobController, onTap: onDateTap),
      ],
    );
  }
}

// --- Helper Widgets for Form Fields ---

class _FieldLabelAndInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _FieldLabelAndInput({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderField extends StatelessWidget {
  final String selectedGender;
  final VoidCallback onTap;

  const _GenderField({required this.selectedGender, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedGender.isEmpty ? 'Select Gender' : selectedGender,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: selectedGender.isEmpty ? Colors.grey.shade500 : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final TextEditingController dobController;
  final VoidCallback onTap;

  const _DateField({required this.dobController, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dobController.text,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: dobController.text == 'dd/mm/yyyy' ? Colors.grey.shade500 : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Iconsax.calendar,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}