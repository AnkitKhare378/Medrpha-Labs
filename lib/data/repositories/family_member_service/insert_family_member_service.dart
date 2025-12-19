// File: lib/data/repositories/family_member_service/insert_family_member_service.dart (CORRECTED)

import 'package:intl/intl.dart';

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/FamilyMemberM/insert_family_member_model.dart';

class InsertFamilyMemberService {
  static const String _apiUrl = '${ApiConstants.insertFamilyMember}';

  Future<InsertFamilyMemberResponseModel> insertMember({
    required String firstName,
    required String lastName,
    required String gender,
    required String bloodGroup,
    required String userId, // API expects String
    required String existingPhoto,
    String? photoPath,
    required double heightCM, // 🎯 Changed to double
    required double weightKG, // 🎯 Changed to double
    required String address,
    required int relationId, // 🎯 Changed to int
    required DateTime dateOfBirth,
    required int id, // 🎯 Changed to int
    required int age, // 🎯 Changed to int
  }) async {
    final String dateOfBirthString = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateOfBirth);
    // All API fields are sent as strings in the multipart request
    final Map<String, String> fields = {
      'FirstName': firstName,
      'LastName': lastName,
      'Gender': gender,
      'BloodGroup': bloodGroup,
      'UserId': userId,
      'ExistingPhoto': existingPhoto,
      // 🎯 Convert doubles to string
      'HeightCM': heightCM.toString(),
      'WeightKG': weightKG.toString(),
      'Address': address,
      // 🎯 Convert ints to string
      'RelationId': relationId.toString(),
      'DateOfBirth': dateOfBirthString,
      'Id': id.toString(),
      'Age': age.toString(),
    };

    final jsonResponse = await ApiCall.postMultipart(
      _apiUrl,
      fields,
      filePath: photoPath,
      fileField: 'UploadPhoto',
    );

    // Check for success status before returning the model
    if (jsonResponse['succeeded'] == true) {
      return InsertFamilyMemberResponseModel.fromJson(jsonResponse);
    } else {
      throw Exception(jsonResponse['message'] ?? 'Failed to insert family member.');
    }
  }
}