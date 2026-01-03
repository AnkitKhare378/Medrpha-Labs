import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import 'package:provider/provider.dart';
import '../../../../models/FamilyMemberM/get_family_members_model.dart';
import '../../../../view_model/FamilyMemberVM/DeleteFamilyMember/family_member_delete_cubit.dart';
import '../../../../view_model/FamilyMemberVM/UpdateFamilyMember/family_member_update_cubit.dart';
import '../../../../view_model/FamilyMemberVM/get_family_members_view_model.dart'; // Contains GetFamilyMembersCubit/State
import '../../../../view_model/provider/family_provider.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../HomeScreen/pages/widgets/add_more_test_button.dart';
import '../widgets/family_member_shimmer.dart';
import 'add_member_page.dart';
import 'update_member_page.dart';

class FamilyMembersPage extends StatefulWidget {
  const FamilyMembersPage({super.key});

  @override
  State<FamilyMembersPage> createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends State<FamilyMembersPage> {
  static const Map<int, String> relationMap = {
    3: "Wify",
    4: "Brother",
    5: "Father",
    6: "Sister",
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch initial data when the page loads
      context.read<GetFamilyMembersCubit>().fetchFamilyMembers();
    });
  }

  String _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return '$age yrs';
  }

  String _getRelationName(int relationId) {
    return relationMap[relationId] ?? 'Unknown';
  }

  Future<bool> _confirmDelete(BuildContext context, String name) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Confirm Deletion',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          content: Text('Are you sure you want to delete $name from your family members?',
              style: GoogleFonts.poppins(fontSize: 14)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel',
                  style: GoogleFonts.poppins(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete',
                  style: GoogleFonts.poppins(color: Colors.redAccent)),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Widget _memberCard({
    required String initial,
    required String name,
    required String relation,
    required String age,
    required String image,
    required double completion,
    required VoidCallback onTap,
    required VoidCallback onDelete,
    bool isSelected = false,
  }) {
    const Color cardPrimaryColor = Colors.blueAccent; // Keeping original color for consistency

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cardPrimaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? cardPrimaryColor.withOpacity(0.2)
                  : cardPrimaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: cardPrimaryColor.withOpacity(0.15),
              child: Image.network('${ApiConstants.familyMembersImageUrl}${image}'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        relation,
                        style: GoogleFonts.poppins(
                          color: cardPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Age: $age',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: completion,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                    backgroundColor: cardPrimaryColor.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      cardPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Profile completion: ${(completion * 100).toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.delete,
                  size: 24,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to calculate profile completion percentage based on filled fields
  double _getCompletion(FamilyMemberModel member) {
    int totalFields = 10; // id, userId, relationMaster are excluded
    int filledFields = 0;

    // Check non-nullable fields based on your model
    if (member.firstName.isNotEmpty) filledFields++;
    if (member.lastName.isNotEmpty) filledFields++;
    if (member.age > 0) filledFields++;
    if (member.relationId > 0) filledFields++;
    if (member.gender.isNotEmpty) filledFields++;
    // member.dateOfBirth is required
    if (member.heightCM > 0) filledFields++;
    if (member.weightKG > 0) filledFields++;
    if (member.address.isNotEmpty) filledFields++;

    // Check nullable fields
    if (member.bloodGroup != null && member.bloodGroup!.isNotEmpty) filledFields++;
    if (member.uploadPhoto != null && member.uploadPhoto!.isNotEmpty) filledFields++;

    return filledFields / totalFields;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        appBar: AppBar(
          title: Text(
            'Family Members',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: BlocListener<FamilyMemberDeleteCubit, FamilyMemberDeleteState>(
          listener: (context, state) {
            if (state is FamilyMemberDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              // After successful deletion, refresh the list
              context.read<GetFamilyMembersCubit>().refreshMembers();
            } else if (state is FamilyMemberDeleteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red),
              );
              // If there was an error, refresh to ensure the list state is correct
              context.read<GetFamilyMembersCubit>().refreshMembers();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<GetFamilyMembersCubit, GetFamilyMembersState>(
                    builder: (context, state) {
                      if (state is GetFamilyMembersLoaded) {
                        if (state.members.isEmpty) {
                          return const Center(
                            child: Text('No family members found. Tap "Add new member" to begin.'),
                          );
                        }

                        // Build the list from the fetched data
                        return ListView(
                          padding: const EdgeInsets.only(top: 16),
                          children: state.members.map((member) {
                            final memberId = member.id;
                            String initial = member.firstName.isNotEmpty
                                ? member.firstName[0].toUpperCase()
                                : '?';
                            String age = _calculateAge(member.dateOfBirth);
                            double completion = _getCompletion(member);
                            String relationName = _getRelationName(member.relationId);

                            // Use Consumer to listen for changes in the selected member
                            return Consumer<FamilyProvider>(
                              builder: (context, familyProvider, child) {
                                // Check if this specific member is the one currently selected
                                final bool isSelected = familyProvider.selectedMember?.id == memberId;

                                return Dismissible(
                                  key: ValueKey(memberId),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade600,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: const Icon(Icons.delete, color: Colors.white),
                                  ),
                                  confirmDismiss: (direction) async {
                                    return await _confirmDelete(context, member.firstName);
                                  },
                                  onDismissed: (direction) {
                                    context.read<FamilyMemberDeleteCubit>().deleteMember(memberId);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _memberCard(
                                      isSelected: isSelected, // Pass the selection state to the card
                                      image: member.uploadPhoto ?? '',
                                      initial: initial,
                                      name: '${member.firstName} ${member.lastName}',
                                      relation: relationName,
                                      age: age,
                                      completion: completion,
                                      onTap: () async {
                                        familyProvider.selectMember(member);
                                        context.read<FamilyMemberUpdateCubit>().resetState();

                                        await Navigator.of(context).push(
                                          SlidePageRoute(
                                            page: UpdateMemberPage(member: member),
                                          ),
                                        );

                                        context.read<GetFamilyMembersCubit>().refreshMembers();
                                      },
                                      onDelete: () async {
                                        if (await _confirmDelete(context, member.firstName)) {
                                          context.read<FamilyMemberDeleteCubit>().deleteMember(memberId);
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      }

                      // Handle loading and error states below
                      if (state is GetFamilyMembersLoading ||
                          state is GetFamilyMembersInitial) {
                        return const FamilyMemberShimmer();
                      }

                      if (state is GetFamilyMembersError) {
                        return Center(
                            child: Text(
                                'Failed to load members: ${state.message}'));
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),

                AddMoreTestButton(
                  onPressed: () async {
                    // Navigate to add new member page
                    await Navigator.of(
                      context,
                    ).push(SlidePageRoute(page: const AddNewMemberPage()));
                    // Refresh the list when returning from add screen
                    context.read<GetFamilyMembersCubit>().refreshMembers();
                  },
                  title: '+ Add new member',
                  backgroundColor: Colors.blueAccent,
                  textColor: Colors.white,
                  borderColor: Colors.blueAccent,
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}