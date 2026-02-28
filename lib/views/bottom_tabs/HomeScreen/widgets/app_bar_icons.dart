import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/apiConstant/api_constant.dart';
import '../../../../config/color/colors.dart';
import '../../../../models/FamilyMemberM/get_family_members_model.dart';
import '../../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../../view_model/provider/family_provider.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../../Dashboard/pages/notification_page.dart';
import '../../ProfileScreen/pages/family_members_page.dart';

class AppBarIcons extends StatefulWidget {
  final String? profileUrl; // ✅ Parameter passed from CustomerBloc in CustomHomeAppBar

  const AppBarIcons({super.key, this.profileUrl});

  @override
  State<AppBarIcons> createState() => _AppBarIconsState();
}

class _AppBarIconsState extends State<AppBarIcons> {
  int _currentUserId = 0;
  static const Map<int, String> relationMap = {
    3: "Wife",
    4: "Brother",
    5: "Father",
    6: "Sister",
  };

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    if (mounted) {
      setState(() {
        _currentUserId = id ?? 0;
      });
    }
  }

  String _getRelationName(int relationId) {
    return relationMap[relationId] ?? 'Family Member';
  }

  void _handleUserIconClick(BuildContext context) {
    // 🔥 If user not logged in → switch to Profile tab
    if (_currentUserId == 0) {
      context.read<DashboardBloc>().add(DashboardTabChanged(4));
      return;
    }

    // ✅ If logged in → continue normal flow
    final familyProvider =
    Provider.of<FamilyProvider>(context, listen: false);

    if (familyProvider.selectedMember == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FamilyMembersPage(),
        ),
      );
    } else {
      _showSelectedMemberModal(context, familyProvider.selectedMember!);
    }
  }

  void _showSelectedMemberModal(BuildContext context, FamilyMemberModel member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text("Active Profile",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    backgroundImage: member.uploadPhoto != null &&
                        member.uploadPhoto!.isNotEmpty
                        ? NetworkImage(
                        '${ApiConstants.familyMembersImageUrl}${member.uploadPhoto}')
                        : null,
                    child: member.uploadPhoto == null ||
                        member.uploadPhoto!.isEmpty
                        ? Icon(Icons.person, color: AppColors.primaryColor)
                        : null,
                  ),
                  title: Text(
                    "${member.firstName} ${member.lastName}",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _getRelationName(member.relationId),
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FamilyMembersPage()));
                    },
                    child: Text(
                      "Change",
                      style: GoogleFonts.poppins(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Listen to FamilyProvider for selected profile
    final familyProvider = context.watch<FamilyProvider>();
    final member = familyProvider.selectedMember;

    // ✅ Logic to decide which image to show
    String? finalImage;

    if (member != null && member.uploadPhoto != null && member.uploadPhoto!.isNotEmpty) {
      // Priority 1: Selected Family Member
      finalImage = '${ApiConstants.familyMembersImageUrl}${member.uploadPhoto}';
    } else if (widget.profileUrl != null && widget.profileUrl!.isNotEmpty) {
      // Priority 2: Primary Customer Photo (from Bloc)
      // Note: Adjust base URL if customer photos are in a different folder
      finalImage = 'https://www.online-tech.in/CustomerImage/${widget.profileUrl}';
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () => _handleUserIconClick(context),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                // Highlight border if a family member is active
                color: member != null ? AppColors.primaryColor : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              backgroundImage: finalImage != null ? NetworkImage(finalImage) : null,
              child: finalImage == null
                  ? const Icon(FontAwesomeIcons.user, size: 14, color: Colors.black)
                  : null,
            ),
          ),
        ),

        const SizedBox(width: 4),

        IconButton(
          icon: const Icon(FontAwesomeIcons.bell, size: 16),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const NotificationPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}