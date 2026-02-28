class CustomerData {
  final int id;
  final String customerName;
  final String emailId;
  final String phoneNumber;
  final double walletAmount;
  final String? photo;
  final String? dob;        // New field
  final int? bloodGroup;    // New field
  final int? gender;        // New field

  CustomerData({
    required this.id,
    required this.customerName,
    required this.emailId,
    required this.phoneNumber,
    required this.walletAmount,
    this.photo,
    this.dob,
    this.bloodGroup,
    this.gender,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] as int? ?? 0,
      customerName: json['customerName'] as String? ?? 'N/A',
      emailId: json['emailId'] as String? ?? 'N/A',
      phoneNumber: json['phoneNumber'] as String? ?? 'N/A',
      walletAmount: (json['walletAmount'] as num? ?? 0.0).toDouble(),
      photo: json['photo'] as String?,
      dob: json['dob'] as String?,
      bloodGroup: json['bloodGroup'] as int?,
      gender: json['gender'] as int?,
    );
  }

  static CustomerData empty() => CustomerData(
    id: 0,
    customerName: 'N/A',
    emailId: 'N/A',
    phoneNumber: 'N/A',
    walletAmount: 0.0,
    photo: null,
    dob: null,
    bloodGroup: null,
    gender: null,
  );
}

class CustomerResponse {
  final CustomerData? data;
  final List<String> messages; // Included from JSON list
  final bool succeeded;
  final String message;
  final int totalCount;
  final int totalPages;

  CustomerResponse({
    this.data,
    required this.messages,
    required this.succeeded,
    required this.message,
    required this.totalCount,
    required this.totalPages,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      data: json['data'] != null ? CustomerData.fromJson(json['data']) : null,
      messages: (json['messages'] as List? ?? []).map((e) => e.toString()).toList(),
      succeeded: json['succeeded'] as bool? ?? false,
      message: json['message'] as String? ?? 'Unknown Message',
      totalCount: json['totalCount'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}