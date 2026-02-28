import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/widgets/family_members_icon_section.dart';
import 'package:provider/provider.dart';
import '../../../../models/FamilyMemberM/get_family_members_model.dart';
import '../../../../view_model/FamilyMemberVM/DeleteFamilyMember/family_member_delete_cubit.dart';
import '../../../../view_model/FamilyMemberVM/UpdateFamilyMember/family_member_update_cubit.dart';
import '../../../../view_model/FamilyMemberVM/get_family_members_view_model.dart';
import '../../../../view_model/FamilyMemberVM/relation_cubit.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetching both members and relation mapping on load
      context.read<GetFamilyMembersCubit>().fetchFamilyMembers();
      context.read<RelationCubit>().fetchRelations();
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
              child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete', style: GoogleFonts.poppins(color: Colors.redAccent)),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  Widget _memberCard({
    required String name,
    required String relation,
    required String age,
    required String image,
    required VoidCallback onTap,
    required VoidCallback onDelete,
    required VoidCallback onEdit,
    bool isSelected = false,
  }) {
    const Color activeColor = Colors.blueAccent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? activeColor.withOpacity(0.2) : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isSelected ? activeColor : Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          '${ApiConstants.familyMembersImageUrl}$image',
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(Icons.check, color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? activeColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: activeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          relation,
                          style: GoogleFonts.poppins(
                            color: activeColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Age: $age',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FamilyMembersIconSection(onDelete: onDelete, onEdit: onEdit)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(
            'Family Members',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocListener<FamilyMemberDeleteCubit, FamilyMemberDeleteState>(
          listener: (context, state) {
            if (state is FamilyMemberDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.read<GetFamilyMembersCubit>().refreshMembers();
            } else if (state is FamilyMemberDeleteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
              context.read<GetFamilyMembersCubit>().refreshMembers();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(
                  // Outer BlocBuilder to get Relations
                  child: BlocBuilder<RelationCubit, RelationState>(
                    builder: (context, relationState) {
                      // Create a local mapping for quick lookup
                      final Map<int, String> relationMap = {};
                      if (relationState is RelationLoaded) {
                        for (var r in relationState.relations) {
                          relationMap[r.id] = r.relationName;
                        }
                      }

                      // Inner BlocBuilder for Family Members
                      return BlocBuilder<GetFamilyMembersCubit, GetFamilyMembersState>(
                        builder: (context, state) {
                          if (state is GetFamilyMembersLoaded) {
                            if (state.members.isEmpty) {
                              return Center(
                                child: Text(
                                  'No family members found.\nTap "+ Add new member" to begin.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(color: Colors.grey),
                                ),
                              );
                            }

                            if (state.members.isNotEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.read<FamilyProvider>().setDefaultMember(state.members.first);
                              });
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.only(top: 16),
                              itemCount: state.members.length,
                              itemBuilder: (context, index) {
                                final member = state.members[index];
                                final memberId = member.id;
                                String age = _calculateAge(member.dateOfBirth);

                                // Dynamic Relation Lookup
                                String relationName = relationMap[member.relationId] ?? 'Unknown';

                                return Consumer<FamilyProvider>(
                                  builder: (context, familyProvider, child) {
                                    final bool isSelected = familyProvider.selectedMember?.id == memberId;

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: _memberCard(
                                        isSelected: isSelected,
                                        image: member.uploadPhoto ?? '',
                                        name: '${member.firstName} ${member.lastName}',
                                        relation: relationName,
                                        age: age,
                                        onTap: () {
                                          familyProvider.selectMember(member);
                                          context.read<FamilyMemberUpdateCubit>().resetState();
                                          Navigator.pop(context);
                                        },
                                        onEdit: () async {
                                          await Navigator.of(context).push(
                                            SlidePageRoute(page: UpdateMemberPage(member: member)),
                                          );
                                          context.read<GetFamilyMembersCubit>().refreshMembers();
                                        },
                                        onDelete: () async {
                                          if (await _confirmDelete(context, member.firstName)) {
                                            context.read<FamilyMemberDeleteCubit>().deleteMember(memberId);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }

                          if (state is GetFamilyMembersLoading || state is GetFamilyMembersInitial) {
                            return const FamilyMemberShimmer();
                          }

                          return const SizedBox.shrink();
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: AddMoreTestButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        SlidePageRoute(page: const AddNewMemberPage()),
                      );
                      context.read<GetFamilyMembersCubit>().refreshMembers();
                    },
                    title: '+ Add new member',
                    backgroundColor: Colors.blueAccent,
                    textColor: Colors.white,
                    borderColor: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}