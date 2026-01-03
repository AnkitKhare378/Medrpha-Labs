import 'package:flutter/material.dart';
import '../../../../models/FamilyMemberM/get_family_members_model.dart';

class FamilyProvider extends ChangeNotifier {
  FamilyMemberModel? _selectedMember;

  FamilyMemberModel? get selectedMember => _selectedMember;

  void selectMember(FamilyMemberModel member) {
    _selectedMember = member;
    notifyListeners();
  }

  void clearSelection() {
    _selectedMember = null;
    notifyListeners();
  }
}