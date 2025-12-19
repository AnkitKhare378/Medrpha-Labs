// lib/models/AddressM/get_user_address_by_id_model.dart (CORRECTED)

class GetUserAddressByIdModel {
  final int id;
  final int addressTypeID;
  final String? addressType; // Can be null in the response
  final String userId;
  final String addressTitle;
  final String faltHousNumber;
  final String street;
  final String locality;
  final String pincode;

  GetUserAddressByIdModel({
    required this.id,
    required this.addressTypeID,
    this.addressType,
    required this.userId,
    required this.addressTitle,
    required this.faltHousNumber,
    required this.street,
    required this.locality,
    required this.pincode,
  });

  factory GetUserAddressByIdModel.fromJson(Map<String, dynamic> json) {
    return GetUserAddressByIdModel(
      id: json['id'] as int,
      addressTypeID: json['addressTypeID'] as int,
      addressType: json['addressType'] as String?,
      userId: json['userId'] as String,
      addressTitle: json['addressTitle'] as String,
      faltHousNumber: json['faltHousNumber'] as String,
      street: json['street'] as String,
      locality: json['locality'] as String,
      pincode: json['pincode'] as String,
    );
  }

  /// Converts the model to a Map<String, String> suitable for the existing AddAddressPage logic (for editing).
  Map<String, String> toEditMap() {
    String typeName;
    // 🛠️ CRITICAL FIX: Base the 'type' string on the reliable addressTypeID.
    switch (addressTypeID) {
      case 1:
        typeName = 'Home';
        break;
      case 2:
        typeName = 'Office';
        break;
      case 3:
        typeName = 'Other';
        break;
      default:
        typeName = 'Unknown';
    }

    return {
      'id': id.toString(), // Include the ID for the update request later
      'title': addressTitle,
      'flat': faltHousNumber,
      'street': street,
      'locality': locality,
      'pincode': pincode,
      // Assign the type name derived from the addressTypeID
      'type': typeName,
      // Also pass the ID itself if needed elsewhere, though 'type' is what _populateForm needs.
      'addressTypeId': addressTypeID.toString(),
    };
  }
}