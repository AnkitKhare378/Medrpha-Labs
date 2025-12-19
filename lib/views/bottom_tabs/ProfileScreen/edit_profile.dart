import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/color/colors.dart';
import '../../../data/repositories/customer_service/edit_profile_service.dart';
import '../../../view_model/CustomerVM/edit_profile_cubit.dart'; // Ensure this path is correct
import 'widgets/custom_app_bar.dart';
import 'widgets/date_picker_modal.dart';
import 'widgets/gender_picker_modal.dart';
import 'widgets/image_picker_modal.dart';
import 'widgets/photo_upload_button.dart';
import 'widgets/profile_form_fields.dart';

class EditProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  EditProfileScreen({Key? key, required this.name, required this.email, required this.phone });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit(EditProfileService()),
      child: _EditProfileView(name: name, email: email, phone: phone),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const _EditProfileView({
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<_EditProfileView> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController(text: "dd/mm/yyyy"); // DOB might still be a placeholder if not passed

  String selectedGender = 'Male';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  DateTime? selectedDate;

  int? _currentUserId;
  bool _isLoadingInitialData = true;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
    phoneController.text = widget.phone;

    final nameParts = widget.name.trim().split(' ');
    firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
    lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    _loadInitialData();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');

    if (mounted) {
      setState(() {
        _currentUserId = id;
        _isLoadingInitialData = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveProfile(BuildContext context) { // ⬅️ MODIFIED
    if (_currentUserId == null || _currentUserId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User ID not found. Please log in.'), backgroundColor: Colors.red),
      );
      return;
    }

    final cubit = context.read<EditProfileCubit>();

    final String fullName = "${firstNameController.text.trim()} ${lastNameController.text.trim()}";
    final String cleanPhone = phoneController.text.replaceAll(RegExp(r'[^\d]'), '');

    cubit.updateCustomer(
      id: _currentUserId!,
      customerName: fullName,
      emailId: emailController.text.trim(),
      phoneNumber: cleanPhone,
      photoPath: _selectedImage?.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingInitialData) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryColor,)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Profile updated successfully!'),
                backgroundColor: const Color(0xFF2196F3),
              ),
            );
            Navigator.pop(context);
          } else if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Save failed: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            // 1. Custom App Bar
            const CustomAppBar(title: 'Edit profile'),

            // 2. Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photo',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 3. Photo Upload Button (with Image Picker Modal)
                    PhotoUploadButton(
                      onTap: () => showImagePickerModal(
                        context: context,
                        onCameraPressed: () => _pickImage(ImageSource.camera),
                        onGalleryPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                    _selectedImage != null
                        ? Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                          child: CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(_selectedImage!)
                          )
                      ),
                    )
                        : const SizedBox.shrink(),

                    const SizedBox(height: 24),

                    // 4. Form Fields
                    ProfileFormFields(
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      phoneController: phoneController,
                      emailController: emailController,
                      selectedGender: selectedGender,
                      dobController: dobController,
                      onGenderTap: () async {
                        final result = await showGenderPickerModal(context, selectedGender);
                        if (result != null) {
                          setState(() {
                            selectedGender = result;
                          });
                        }
                      },
                      onDateTap: () async {
                        final result = await showDatePickerModal(context, selectedDate);
                        if (result != null) {
                          setState(() {
                            selectedDate = result;
                            dobController.text = DateFormat('dd/MM/yyyy').format(result);
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 40),

                    // 5. Save Button (BlocBuilder handles loading state)
                    BlocBuilder<EditProfileCubit, EditProfileState>(
                      builder: (context, state) {
                        final bool isLoading = state is EditProfileLoading;

                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => _saveProfile(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              'Save',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}