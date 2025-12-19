class CustomerData {
  final int id;
  final String customerName;
  final String emailId;
  final String phoneNumber;
  final double walletAmount; // ⬅️ NEW Field
  final String? photo; // ⬅️ NEW Field

  CustomerData({
    required this.id,
    required this.customerName,
    required this.emailId,
    required this.phoneNumber,
    required this.walletAmount, // ⬅️ Added to constructor
    this.photo, // ⬅️ Added to constructor
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] as int? ?? 0,
      customerName: json['customerName'] as String? ?? 'N/A',
      emailId: json['emailId'] as String? ?? 'N/A',
      phoneNumber: json['phoneNumber'] as String? ?? 'N/A',
      // Safely parse walletAmount as a double (using num to handle potential int or double from JSON)
      walletAmount: (json['walletAmount'] as num? ?? 0.0).toDouble(), // ⬅️ Parsed NEW Field
      photo: json['photo'] as String?, // ⬅️ Parsed NEW Field (nullable)
    );
  }

  // Optional: A static method for an empty/default model state
  static CustomerData empty() => CustomerData(
    id: 0,
    customerName: 'N/A',
    emailId: 'N/A',
    phoneNumber: 'N/A',
    walletAmount: 0.0,
    photo: null,
  );
}

class CustomerResponse {
  final CustomerData? data;
  final bool succeeded;
  final String message;
  // Note: totalCount and totalPages from the response are omitted as they are 0 and likely not used here.

  CustomerResponse({
    this.data,
    required this.succeeded,
    required this.message,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return CustomerResponse(
      data: dataJson != null ? CustomerData.fromJson(dataJson) : null,
      succeeded: json['succeeded'] as bool? ?? false,
      message: json['message'] as String? ?? 'Unknown Message',
    );
  }
}