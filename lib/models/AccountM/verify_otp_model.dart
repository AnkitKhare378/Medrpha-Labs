class VerifyOtpModel {
  final VerifyOtpData? data;
  final List<String>? messages;
  final String? message;
  final bool succeeded;

  VerifyOtpModel({
    this.data,
    this.messages,
    this.message,
    required this.succeeded,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      data: json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null,
      messages: (json['messages'] as List?)?.map((e) => e.toString()).toList(),
      message: json['message'],
      succeeded: json['succeeded'] ?? false,
    );
  }
}

class VerifyOtpData {
  final int? id;
  final String? customerName;
  final String? emailId;
  final String? phoneNumber;
  final bool? isConfirmed;
  final bool? isActiveUser;

  VerifyOtpData({
    this.id,
    this.customerName,
    this.emailId,
    this.phoneNumber,
    this.isConfirmed,
    this.isActiveUser,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      id: json['id'],
      customerName: json['customerName'],
      emailId: json['emailId'],
      phoneNumber: json['phoneNumber'],
      isConfirmed: json['isConfirmed'],
      isActiveUser: json['isActiveUser'],
    );
  }
}
