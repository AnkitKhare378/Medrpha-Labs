import 'package:flutter/material.dart';
import '../../../../models/FamilyMemberM/get_family_members_model.dart';

class FamilyProvider extends ChangeNotifier {
  FamilyMemberModel? _selectedMember;
  // ✅ Added list to hold members
  List<FamilyMemberModel> _members = [];

  FamilyMemberModel? get selectedMember => _selectedMember;
  // ✅ Getter for members
  List<FamilyMemberModel> get members => _members;

  void setDefaultMember(FamilyMemberModel member) {
    if (_selectedMember == null) {
      _selectedMember = member;
      notifyListeners();
    }
  }

  void setInitialMember(List<FamilyMemberModel> members) {
    // ✅ Store the members list
    _members = members;
    if (_selectedMember == null && members.isNotEmpty) {
      _selectedMember = members.first;
      notifyListeners();
    }
  }

  void selectMember(FamilyMemberModel member) {
    _selectedMember = member;
    notifyListeners();
  }

  // ✅ Updated to clear both selection and the members list
  void clearSelection() {
    _selectedMember = null;
    _members = [];
    notifyListeners();
  }
}