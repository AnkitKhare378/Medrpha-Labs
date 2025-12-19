// File: lib/viewmodels/insert_family_member_view_model.dart (CORRECTED)

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core'; // Ensure DateTime is available

import '../../data/repositories/family_member_service/insert_family_member_service.dart';
import '../../models/FamilyMemberM/insert_family_member_model.dart';


class InsertFamilyMemberViewModel extends ChangeNotifier {
  final InsertFamilyMemberService _service = InsertFamilyMemberService();

  bool _isLoading = false;
  String? _errorMessage;
  InsertFamilyMemberResponseModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  InsertFamilyMemberResponseModel? get response => _response;

  /// Submits the family member data to the API.
  Future<void> saveMember({
    required String firstName,
    required String lastName,
    required String gender,
    required String bloodGroup,
    // 🎯 Must receive as String from the UI, but will convert to int for API
    required String relationId,
    required String dateOfBirth, // Input String from UI
    // 🎯 Must receive as String from the UI, but will convert to double for API
    required String heightCM,
    // 🎯 Must receive as String from the UI, but will convert to double for API
    required String weightKG,
    required String address,
    // 🎯 Must receive as String from the UI, but will convert to int for API
    required String age,
    File? photoFile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _response = null;
    notifyListeners();

    try {
      // 1. Get the current UserId.
      final prefs = await SharedPreferences.getInstance();
      final userIdInt = prefs.getInt('user_id');

      if (userIdInt == null) {
        throw Exception("User is not logged in. Cannot save family member.");
      }
      final userId = userIdInt.toString();

      // 2. Parse/Convert data to match the service's expected types (int/double/DateTime)
      final int relationIdInt = int.tryParse(relationId) ?? 0;
      final int ageInt = int.tryParse(age) ?? 0;
      final double heightDouble = double.tryParse(heightCM) ?? 0.0;
      final double weightDouble = double.tryParse(weightKG) ?? 0.0;

      // ✅ CORRECT: Convert String dateOfBirth to DateTime
      final DateTime? dateOfBirthDateTime = DateTime.tryParse(dateOfBirth);

      if (dateOfBirthDateTime == null) {
        // This exception handles cases where the date string from the UI is invalid
        throw Exception("Invalid date of birth format. Expected YYYY-MM-DD format.");
      }


      // 3. Call the service
      final result = await _service.insertMember(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        bloodGroup: bloodGroup,
        userId: userId,
        existingPhoto: photoFile != null ? 'New' : 'No',
        photoPath: photoFile?.path,
        heightCM: heightDouble,
        weightKG: weightDouble,
        address: address,
        relationId: relationIdInt,
        dateOfBirth: dateOfBirthDateTime, // ✅ CORRECT: Passing DateTime to the service
        id: 0,
        age: ageInt,
      );

      _response = result;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (kDebugMode) {
        print('Error in ViewModel: $_errorMessage');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}