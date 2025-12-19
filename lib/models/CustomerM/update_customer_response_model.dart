// lib/models/update_customer_response_model.dart

class UpdateCustomerResponse {
  final CustomerData? data;
  final String? message;
  final List<String>? messages;
  final bool succeeded;
  final int totalCount;
  final int totalPages;

  UpdateCustomerResponse({
    this.data,
    this.message,
    this.messages,
    required this.succeeded,
    this.totalCount = 0,
    this.totalPages = 0,
  });

  factory UpdateCustomerResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCustomerResponse(
      data: json['data'] != null ? CustomerData.fromJson(json['data']) : null,
      message: json['message'] as String?,
      messages: json['messages'] != null
          ? List<String>.from(json['messages'])
          : null,
      succeeded: json['succeeded'] ?? false,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class CustomerData {
  final int id;
  final String customerName;
  final String emailId;
  final String phoneNumber;
  final String? phoneOTP;
  final String? emailOTP;
  final bool isConfirmed;
  final bool isMailConfirmed;
  // 🎯 CORRECTED: Based on the response body, this is a String (the filename).
  final String? uploadPhoto;
  final String? emailOTPValidDateTime;
  final String? phoneOTPValidDateTime;
  final bool isActiveUser;
  final String? userProfile;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  CustomerData({
    required this.id,
    required this.customerName,
    required this.emailId,
    required this.phoneNumber,
    this.phoneOTP,
    this.emailOTP,
    required this.isConfirmed,
    required this.isMailConfirmed,
    this.uploadPhoto,
    this.emailOTPValidDateTime,
    this.phoneOTPValidDateTime,
    required this.isActiveUser,
    this.userProfile,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] ?? 0,
      customerName: json['customerName'] ?? '',
      emailId: json['emailId'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      phoneOTP: json['phoneOTP'] as String?,
      emailOTP: json['emailOTP'] as String?,
      isConfirmed: json['isConfirmed'] ?? false,
      isMailConfirmed: json['isMailConfirmed'] ?? false,
      // 🎯 CORRECTED PARSING: Directly read the string value.
      uploadPhoto: json['uploadPhoto'] as String?,
      emailOTPValidDateTime: json['emailOTPValidDateTime'] as String?,
      phoneOTPValidDateTime: json['phoneOTPValidDateTime'] as String?,
      isActiveUser: json['isActiveUser'] ?? false,
      userProfile: json['userProfile'] as String?,
      createdBy: json['created_by'] as String?,
      createdDate: json['created_date'] as String?,
      modifiedBy: json['modified_by'] as String?,
      modifiedDate: json['modified_date'] as String?,
    );
  }
}
