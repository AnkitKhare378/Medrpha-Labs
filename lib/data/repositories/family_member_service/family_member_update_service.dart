// File: lib/data/repositories/family_member_service/family_member_update_service.dart

import 'dart:io';
import '../../../../config/apiConstant/api_constant.dart'; // Adjust path
import '../../../../core/network/api_call.dart'; // Adjust path
import '../../../../models/FamilyMemberM/family_member_update_response.dart';

class FamilyMemberUpdateService {
  static const String _apiUrl = '${ApiConstants.baseUrl}Customer/FamilyMemberUpdate';

  Future<FamilyMemberUpdateResponse> updateMember({
    required int id,
    required String userId,
    required String firstName,
    required String lastName,
    required String age,
    required String relationId,
    required String gender,
    required String dateOfBirth,
    required String heightCM,
    required String weightKG,
    required String bloodGroup,
    required String address,
    required File? photoFile,
    required String existingPhoto, // Send empty value if no existing photo/url
  }) async {
    // Map all fields to String for the multipart request
    final Map<String, String> fields = {
      "Id": id.toString(),
      "UserId": userId,
      "FirstName": firstName,
      "LastName": lastName,
      "Age": age,
      "RelationId": relationId,
      "Gender": gender,
      "DateOfBirth": dateOfBirth,
      "HeightCM": heightCM,
      "WeightKG": weightKG,
      "BloodGroup": bloodGroup,
      "Address": address,
      "ExistingPhoto": existingPhoto,
    };

    final jsonResponse = await ApiCall.postMultipart(
      _apiUrl,
      fields,
      filePath: photoFile?.path,
      fileField: "UploadPhoto",
    );

    return FamilyMemberUpdateResponse.fromJson(jsonResponse);
  }
}