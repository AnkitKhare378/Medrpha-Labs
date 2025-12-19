// lib/models/user_address_insert_model.dart

import '../../view_model/AddressVM/UserAddressInsert/user_address_insert_event.dart';

class UserAddressInsertRequest {
  final int addressTypeID;
  final String userId;
  final String addressTitle;
  final String flatHousNumber;
  final String street;
  final String locality;
  final String pincode;
  final bool isDefault;
  final String latitude;
  final String longitude;

  UserAddressInsertRequest({
    required this.addressTypeID,
    required this.userId,
    required this.addressTitle,
    required this.flatHousNumber,
    required this.street,
    required this.locality,
    required this.pincode,
    required this.isDefault,
    required this.latitude,
    required this.longitude,
  });

  /// Converts the model instance to a JSON map for the API request body.
  Map<String, dynamic> toJson() {
    return {
      "addressTypeID": addressTypeID,
      "userId": userId,
      "addressTitle": addressTitle,
      "faltHousNumber": flatHousNumber,
      "street": street,
      "locality": locality,
      "pincode": pincode,
      "latitude": latitude,
      "longitude": longitude,
      "isDefault": isDefault,
    };
  }
}

/// Model for the successful response after inserting a user address.
class UserAddressInsertResponse {
  final int data; // The ID of the newly saved address
  final List<String> messages;
  final String message;
  final bool succeeded;

  UserAddressInsertResponse({
    required this.data,
    required this.messages,
    required this.message,
    required this.succeeded,
  });

  /// Factory constructor to create an instance from the JSON response map.
  factory UserAddressInsertResponse.fromJson(Map<String, dynamic> json) {
    return UserAddressInsertResponse(
      data: json['data'] as int,
      messages: List<String>.from(json['messages'] as List),
      message: json['message'] as String,
      succeeded: json['succeeded'] as bool,
    );
  }
}

// lib/models/AddressM/user_address_update_request_model.dart

/// Model for the request body to update an existing user address.
class UserAddressUpdateRequest {
  final String id; // Required for update, kept as String as per constraint
  final int addressTypeID;
  final String userId;
  final String addressTitle;
  final String flatHousNumber;
  final String street;
  final String locality;
  final String pincode;
  final String latitude;
  final String longitude;

  UserAddressUpdateRequest({
    required this.id,
    required this.addressTypeID,
    required this.userId,
    required this.addressTitle,
    required this.flatHousNumber,
    required this.street,
    required this.locality,
    required this.pincode,
    required this.latitude,
    required this.longitude,
  });

  /// Converts the model instance to a JSON map for the API request body.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "addressTypeID": addressTypeID,
      "userId": userId,
      "addressTitle": addressTitle,
      "faltHousNumber": flatHousNumber, // Note the spelling 'faltHousNumber'
      "street": street,
      "locality": locality,
      "pincode": pincode,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}

// 🛠️ NEW: Event for Update operation
class UpdateUserAddress extends UserAddressInsertEvent {
  final UserAddressUpdateRequest request;
  const UpdateUserAddress(this.request);

  @override
  List<Object> get props => [request];
}

/// Model for the successful response after updating a user address.
class UserAddressUpdateResponse {
  final int data;
  final String message;
  final bool succeeded;
  final List<String> messages;

  UserAddressUpdateResponse({
    required this.data,
    required this.message,
    required this.succeeded,
    required this.messages,
  });

  /// Factory constructor to create an instance from the JSON response map.
  factory UserAddressUpdateResponse.fromJson(Map<String, dynamic> json) {
    // Corrected the typo: 'json:['succeeded']' is now 'json['succeeded']'
    return UserAddressUpdateResponse(
      // Safely casting 'data' to an int, using '?? 0' for a default value
      // in case of unexpected null/missing data, though 'as int' is often enough
      // if you're sure about the API contract.
      data: json['data'] as int,

      // Safely casting 'message' to a String.
      message: json['message'] as String,

      // Corrected and safely casting 'succeeded' to a bool.
      succeeded: json['succeeded'] as bool,

      // Properly handling the list of strings, ensuring it's never null by
      // providing an empty list as a fallback.
      messages: List<String>.from(json['messages'] ?? []),
    );
  }
}
