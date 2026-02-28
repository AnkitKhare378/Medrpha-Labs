import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/color/colors.dart';
import '../../../data/repositories/customer_service/edit_profile_service.dart';
import '../../../models/BloodM/get_blood_model.dart';
import '../../../view_model/BloodVM/get_blood_view_model.dart';
import '../../../view_model/CustomerVM/edit_profile_cubit.dart'; // Ensure this path is correct
import 'widgets/custom_app_bar.dart';
import 'widgets/date_picker_modal.dart';
import 'widgets/gender_picker_modal.dart';
import 'widgets/image_picker_modal.dart';
import 'widgets/photo_upload_button.dart';
import 'widgets/profile_form_fields.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const EditProfileScreen({
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
  GetBloodGroupModel? selectedBloodGroup;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
    phoneController.text = widget.phone;

    final nameParts = widget.name.trim().split(' ');
    firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
    lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    _loadInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetBloodGroupBloc>().add(const FetchBloodGroups());
    });
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

  Widget _buildBloodGroupDropdown() {
    return BlocBuilder<GetBloodGroupBloc, GetBloodGroupState>(
      builder: (context, state) {
        List<GetBloodGroupModel> items = [];
        String hint = "Select Blood Group";

        if (state is GetBloodGroupLoading) {
          hint = "Loading...";
        } else if (state is GetBloodGroupLoaded) {
          items = state.bloodGroups;
        } else if (state is GetBloodGroupError) {
          hint = "Error loading data";
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<GetBloodGroupModel>(
              isExpanded: true,
              hint: Text(hint, style: GoogleFonts.poppins(fontSize: 14)),
              value: selectedBloodGroup,
              items: items.map((bg) {
                return DropdownMenuItem(
                  value: bg,
                  child: Text(bg.name, style: GoogleFonts.poppins()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBloodGroup = value;
                });
              },
            ),
          ),
        );
      },
    );
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

    if (selectedBloodGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a blood group'), backgroundColor: Colors.orange),
      );
      return;
    }

    final cubit = context.read<EditProfileCubit>();

    String genderId = selectedGender == 'Male' ? '1' : '2';

    String formattedDob = selectedDate != null
        ? "${DateFormat('yyyy-MM-dd').format(selectedDate!)}T00:00:00.000"
        : "";

    final String fullName = "${firstNameController.text.trim()} ${lastNameController.text.trim()}";
    final String cleanPhone = phoneController.text.replaceAll(RegExp(r'[^\d]'), '');

    cubit.updateCustomer(
      id: _currentUserId!,
      customerName: fullName,
      emailId: emailController.text.trim(),
      phoneNumber: cleanPhone,
      dob: formattedDob,
      gender: genderId,
      bloodGroup: selectedBloodGroup!.id.toString(),
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

                    const SizedBox(height: 0),
                    Text(
                      'Blood Group',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBloodGroupDropdown(),

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