// File: lib/views/bottom_tabs/ProfileScreen/pages/update_member_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ NEW IMPORTS for Blood Group
import '../../../../models/BloodM/get_blood_model.dart';
import '../../../../view_model/BloodVM/get_blood_view_model.dart';

import '../../../../models/FamilyMemberM/get_family_members_model.dart';
import '../../../../models/FamilyMemberM/relation_model.dart';
import '../../../../view_model/FamilyMemberVM/UpdateFamilyMember/family_member_update_cubit.dart';
import '../../../../view_model/FamilyMemberVM/UpdateFamilyMember/family_member_update_state.dart';
import '../../../../view_model/FamilyMemberVM/relation_cubit.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../widgets/bottom_sheets.dart';
import '../widgets/profile_date_field.dart';
import '../widgets/profile_form_textfield.dart';
import '../widgets/profile_gender_field.dart';

class UpdateMemberPage extends StatefulWidget {
  final FamilyMemberModel member;

  const UpdateMemberPage({super.key, required this.member});

  @override
  State<UpdateMemberPage> createState() => _UpdateMemberPageState();
}

class _UpdateMemberPageState extends State<UpdateMemberPage> {
  // Text Controllers
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController dobController;
  late final TextEditingController heightController;
  late final TextEditingController weightController;
  // late final TextEditingController bloodGroupController; // Removed, now using selectedBloodGroup
  late final TextEditingController addressController;
  final TextEditingController ageController = TextEditingController();

  // State Variables
  RelationModel? selectedRelation;
  // ✅ NEW: State variable for Blood Group
  GetBloodGroupModel? selectedBloodGroup;
  String selectedGender = '';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  DateTime? selectedDate;
  bool _isSaving = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();

    // 💡 INITIALIZE CONTROLLERS WITH EXISTING MEMBER DATA
    firstNameController = TextEditingController(text: widget.member.firstName);
    lastNameController = TextEditingController(text: widget.member.lastName);
    heightController = TextEditingController(text: widget.member.heightCM.toString());
    weightController = TextEditingController(text: widget.member.weightKG.toString());
    addressController = TextEditingController(text: widget.member.address);

    // Set initial gender and DOB
    selectedGender = widget.member.gender;
    selectedDate = widget.member.dateOfBirth;
    dobController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(selectedDate!));

    // Set initial blood group model (will be fully set when BLoC loads)
    // ✅ FIX 1: Safely check if bloodGroup is non-null and not empty
    if (widget.member.bloodGroup?.isNotEmpty ?? false) {
      // ✅ FIX 2: Provide a fallback/assert non-null for the GetBloodGroupModel constructor
      selectedBloodGroup = GetBloodGroupModel(id: 0, name: widget.member.bloodGroup!);
      // Alternatively, use:
      // selectedBloodGroup = GetBloodGroupModel(id: 0, name: widget.member.bloodGroup ?? '');
    }

    _calculateAge(); // Calculate initial age
    dobController.addListener(_calculateAge);

    // ✅ Trigger BLoC events
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetBloodGroupBloc>().add(const FetchBloodGroups());
    });
  }

  @override
  void dispose() {
    dobController.removeListener(_calculateAge);
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();
    addressController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    setState(() {
      _userId = id;
    });
    if (id == null) {
      debugPrint('⚠️ User ID not found in local storage.');
    }
  }

  void _calculateAge() {
    if (selectedDate != null) {
      final now = DateTime.now();
      int age = now.year - selectedDate!.year;
      if (now.month < selectedDate!.month || (now.month == selectedDate!.month && now.day < selectedDate!.day)) {
        age--;
      }
      ageController.text = age.toString();
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

  Future<void> _updateMember() async {
    // ✅ UPDATED VALIDATION
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        selectedRelation == null ||
        selectedGender.isEmpty ||
        dobController.text == "dd/mm/yyyy" ||
        ageController.text.isEmpty ||
        selectedBloodGroup == null) { // Check if a blood group is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


    setState(() => _isSaving = true);
    final cubit = context.read<FamilyMemberUpdateCubit>();

    try {
      await cubit.updateMember(
        id: widget.member.id,
        userId: _userId.toString(),
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        gender: selectedGender,
        // ✅ Pass the name from the selectedBloodGroup model
        bloodGroup: selectedBloodGroup!.name,
        relationId: selectedRelation!.id.toString(),
        dateOfBirth: dobController.text, // Ensure format is 'dd/MM/yyyy' or API compliant
        heightCM: heightController.text,
        weightKG: weightController.text,
        address: addressController.text,
        age: ageController.text,
        photoFile: _selectedImage, // New file if selected
        existingPhoto: widget.member.uploadPhoto ?? '', // Send existing URL/Path (or empty string if null)
      );

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected local error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ✅ Blood Group Dropdown Widget (with pre-selection logic)
  Widget _bloodGroupDropdown() {
    return BlocBuilder<GetBloodGroupBloc, GetBloodGroupState>(
      builder: (context, state) {
        String hintText = 'Select Blood Group';
        Widget suffix = const Icon(Icons.arrow_drop_down);
        List<GetBloodGroupModel> items = [];

        if (state is GetBloodGroupLoading) {
          hintText = 'Loading blood groups...';
          suffix = const SizedBox(
              height: 15, width: 15,
              child: CircularProgressIndicator(strokeWidth: 2)
          );
        } else if (state is GetBloodGroupLoaded) {
          items = state.bloodGroups;
          // 💡 SET INITIAL BLOOD GROUP when list is loaded
          if (selectedBloodGroup != null && selectedBloodGroup!.id == 0) {
            // Find the full model using the name we initialized in initState
            final initialSelection = items.firstWhere(
                  (bg) => bg.name == widget.member.bloodGroup,
              orElse: () => items.first, // Fallback
            );
            // We set it in a post-frame callback to avoid calling setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedBloodGroup = initialSelection;
              });
            });
          }
        } else if (state is GetBloodGroupError) {
          hintText = 'Error loading blood groups';
          suffix = const Icon(Icons.error, color: Colors.red);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<GetBloodGroupModel>(
              isExpanded: true,
              // Use the item from the loaded list if it exists, otherwise null
              value: items.contains(selectedBloodGroup) ? selectedBloodGroup : null,
              hint: Text(
                selectedBloodGroup?.name ?? hintText,
                style: GoogleFonts.poppins(
                  color: (state is GetBloodGroupError) ? Colors.red : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              icon: suffix,
              onChanged: (state is GetBloodGroupLoading || state is GetBloodGroupError)
                  ? null
                  : (GetBloodGroupModel? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedBloodGroup = newValue;
                  });
                }
              },
              items: items.map<DropdownMenuItem<GetBloodGroupModel>>((GetBloodGroupModel bloodGroup) {
                return DropdownMenuItem<GetBloodGroupModel>(
                  value: bloodGroup,
                  child: Text(bloodGroup.name, style: GoogleFonts.poppins()),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Relation Dropdown Widget using BLoC (Same as AddNewMemberPage)
  Widget _relationDropdown() {
    return BlocBuilder<RelationCubit, RelationState>(
      builder: (context, state) {
        String hintText = 'Select Relation';
        Widget suffix = const Icon(Icons.arrow_drop_down);
        List<RelationModel> items = [];

        if (state is RelationLoaded) {
          items = state.relations;
          // 💡 SET INITIAL RELATION when relations are loaded for the first time
          if (selectedRelation == null) {
            // We only set it here if it's null (first run). This prevents overwriting user selection.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final initialSelection = items.firstWhere(
                    (r) => r.id == widget.member.relationId,
                orElse: () => items.first, // Fallback to first if ID not found
              );
              setState(() {
                selectedRelation = initialSelection;
              });
            });
          }
        } else if (state is RelationLoading) {
          hintText = 'Loading relations...';
          suffix = const SizedBox(
              height: 15, width: 15, child: CircularProgressIndicator(strokeWidth: 2));
        } else if (state is RelationError) {
          hintText = 'Error loading relations';
          suffix = const Icon(Icons.error, color: Colors.red);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RelationModel>(
              isExpanded: true,
              value: items.contains(selectedRelation) ? selectedRelation : null,
              hint: Text(
                selectedRelation?.relationName ?? hintText,
                style: GoogleFonts.poppins(
                  color: (state is RelationError) ? Colors.red : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              icon: suffix,
              onChanged: (state is RelationLoading || state is RelationError)
                  ? null
                  : (RelationModel? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedRelation = newValue;
                  });
                }
              },
              items: items.map<DropdownMenuItem<RelationModel>>((RelationModel relation) {
                return DropdownMenuItem<RelationModel>(
                  value: relation,
                  child: Text(relation.relationName, style: GoogleFonts.poppins()),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the existing photo URL (or empty string if null)
    final existingPhotoUrl = widget.member.uploadPhoto ?? '';

    return BlocListener<FamilyMemberUpdateCubit, FamilyMemberUpdateState>(
      listener: (context, state) {
        if (state is FamilyMemberUpdateSuccess) {
          showAppSnackBar(context, state.response.message);
          Navigator.pop(context); // Go back to the list screen
        } else if (state is FamilyMemberUpdateError) {
          setState(() => _isSaving = false); // Stop local loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        appBar: AppBar(
          title: Text(
            'Update Member',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Image Upload
              GestureDetector(
                onTap: () {
                  BottomSheets.showImagePickerDialog(
                    context: context,
                    pickImage: _pickImage,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      if (_selectedImage != null)
                        Image.file(
                          _selectedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      else if (existingPhotoUrl.isNotEmpty)
                        Image.network(
                          existingPhotoUrl,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => const Icon(Iconsax.export, color: Colors.blueAccent),
                        )
                      else
                        const Icon(Iconsax.export, color: Colors.blueAccent),

                      const SizedBox(height: 8),
                      Text(
                        _selectedImage != null ? 'Change Photo' : (existingPhotoUrl.isNotEmpty ? 'Change Photo' : 'Upload Photo'),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields (pre-filled by controllers)
              ProfileFormTextField(label: 'First Name', controller: firstNameController),
              ProfileFormTextField(label: 'Last Name', controller: lastNameController),
              _relationDropdown(),
              ProfileGenderField(
                label: 'Gender',
                selectedGender: selectedGender,
                onTap: () {
                  BottomSheets.showGenderPicker(
                    context: context,
                    selectedGender: selectedGender,
                    onGenderSelected: (gender) => setState(() => selectedGender = gender),
                  );
                },
              ),
              ProfileDateField(
                label: 'Date of Birth (DD/MM/YYYY)',
                controller: dobController,
                onTap: () {
                  // ... (Date picker logic remains the same)
                  BottomSheets.showCustomDatePicker(
                    context: context,
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                        dobController.text = DateFormat('dd/MM/yyyy').format(date);
                        _calculateAge();
                      });
                    },
                  );
                },
              ),
              ProfileFormTextField(
                label: 'Age (Auto-calculated)',
                controller: ageController,
                readOnly: true,
                keyboardType: TextInputType.number,
              ),
              ProfileFormTextField(
                label: 'Height (cm)',
                controller: heightController,
                keyboardType: TextInputType.number,
              ),
              ProfileFormTextField(
                label: 'Weight (kg)',
                controller: weightController,
                keyboardType: TextInputType.number,
              ),
              // ✅ REPLACED: TextField with Dropdown
              _bloodGroupDropdown(),

              ProfileFormTextField(
                label: 'Address',
                controller: addressController,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                    // The `_updateMember` function handles the cubit call
                    _updateMember();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: BlocBuilder<FamilyMemberUpdateCubit, FamilyMemberUpdateState>(
                    builder: (context, state) {
                      // Use the Cubit's state to control the loading indicator
                      final isUpdating = state is FamilyMemberUpdateLoading;
                      return isUpdating
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Text(
                        'Update Member',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}