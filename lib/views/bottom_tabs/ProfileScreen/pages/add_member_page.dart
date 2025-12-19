import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../models/BloodM/get_blood_model.dart';
import '../../../../models/FamilyMemberM/relation_model.dart';
import '../../../../view_model/BloodVM/get_blood_view_model.dart';
import '../../../../view_model/FamilyMemberVM/insert_family_member_view_model.dart';
import '../../../../view_model/FamilyMemberVM/relation_cubit.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../widgets/bottom_sheets.dart';
import '../widgets/profile_date_field.dart';
import '../widgets/profile_form_textfield.dart';
import '../widgets/profile_gender_field.dart';

class AddNewMemberPage extends StatefulWidget {
  const AddNewMemberPage({super.key});

  @override
  State<AddNewMemberPage> createState() => _AddNewMemberPageState();
}

class _AddNewMemberPageState extends State<AddNewMemberPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  RelationModel? selectedRelation;

  final TextEditingController dobController = TextEditingController(text: "dd/mm/yyyy");
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  // final TextEditingController bloodGroupController = TextEditingController(); // This is obsolete/not used for selected value
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String selectedGender = '';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  DateTime? selectedDate;
  bool _isSaving = false;

  // The state variable holding the selected Blood Group object
  GetBloodGroupModel? selectedBloodGroup;

  @override
  void initState() {
    super.initState();
    dobController.addListener(_calculateAge);
    // 💡 Trigger the BLoC event to fetch blood groups
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
    // bloodGroupController.dispose(); // Remove if not needed
    addressController.dispose();
    ageController.dispose();
    super.dispose();
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

  Future<void> _saveMember() async {
    // ✅ UPDATED VALIDATION
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        selectedRelation == null ||
        selectedGender.isEmpty ||
        dobController.text == "dd/mm/yyyy" ||
        ageController.text.isEmpty ||
        selectedBloodGroup == null // Check the selected model
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Using Provider for the Insert ViewModel (as per existing code structure)
    final viewModel = Provider.of<InsertFamilyMemberViewModel>(context, listen: false);

    try {
      final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
      final DateTime parsedDate = inputFormat.parse(dobController.text);
      final String dateOfBirthForVM = DateFormat('yyyy-MM-dd').format(parsedDate);
      await viewModel.saveMember(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        gender: selectedGender,
        // ✅ FIX: Pass the name from the selectedBloodGroup model
        bloodGroup: selectedBloodGroup!.name,
        relationId: selectedRelation!.id.toString(),
        dateOfBirth: dateOfBirthForVM,
        heightCM: heightController.text,
        weightKG: weightController.text,
        address: addressController.text,
        age: ageController.text,
        photoFile: _selectedImage,
      );

      if (viewModel.errorMessage != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${viewModel.errorMessage!}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Show success message
        if (mounted) {
          showAppSnackBar(context, viewModel.response?.message ?? 'Member saved successfully!');
          Navigator.pop(context);
        }
      }
    } catch (e) {
      // Handle unexpected local errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Clear loading state
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

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
              value: selectedBloodGroup,
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

  // 💡 NEW: Relation Dropdown Widget using BLoC
  Widget _relationDropdown() {
    return BlocBuilder<RelationCubit, RelationState>(
      builder: (context, state) {
        String hintText = 'Select Relation';
        Widget suffix = const Icon(Icons.arrow_drop_down);
        List<RelationModel> items = [];

        if (state is RelationLoading) {
          hintText = 'Loading relations...';
          suffix = const SizedBox(
              height: 15, width: 15,
              child: CircularProgressIndicator(strokeWidth: 2)
          );
        } else if (state is RelationLoaded) {
          items = state.relations;
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
              value: selectedRelation,
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
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          'Add New Member',
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
                    else
                      const Icon(Iconsax.export, color: Colors.blueAccent), // Use const here

                    const SizedBox(height: 8),
                    Text(
                      _selectedImage != null ? 'Change Photo' : 'Upload Photo',
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

            // Form Fields
            ProfileFormTextField(
              label: 'First Name',
              controller: firstNameController,
            ),
            ProfileFormTextField(
              label: 'Last Name',
              controller: lastNameController,
            ),

            // 💡 REPLACED: TextField with BLoC-powered Dropdown
            _relationDropdown(),

            ProfileGenderField(
              label: 'Gender',
              selectedGender: selectedGender,
              onTap: () {
                BottomSheets.showGenderPicker(
                  context: context,
                  selectedGender: selectedGender,
                  onGenderSelected: (gender) =>
                      setState(() => selectedGender = gender),
                );
              },
            ),
            ProfileDateField(
              label: 'Date of Birth (DD/MM/YYYY)',
              controller: dobController,
              onTap: () {
                BottomSheets.showCustomDatePicker(
                  context: context,
                  selectedDate: selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                      dobController.text = DateFormat('dd/MM/yyyy').format(date);
                      _calculateAge(); // Recalculate age when date is picked
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
            // Blood Group Dropdown
            _bloodGroupDropdown(),

            ProfileFormTextField(
              label: 'Address',
              controller: addressController,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveMember,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  'Save Member',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
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