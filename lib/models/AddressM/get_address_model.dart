// lib/models/AddressM/get_address_model.dart (CORRECTED)

import 'dart:convert';

List<UserAddress> userAddressFromJson(String str) =>
    List<UserAddress>.from(json.decode(str).map((x) => UserAddress.fromJson(x)));

String userAddressToJson(List<UserAddress> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserAddress {
  final int id;
  final int addressTypeId;
  final String? addressType;
  final String userId;
  final String? addressTitle;
  final String? faltHousNumber;
  final String street;
  final String latitude;
  final String longitude;
  final String locality;
  final String pincode;

  UserAddress({
    required this.id,
    required this.addressTypeId,
    this.addressType,
    required this.userId,
    this.addressTitle,
    this.faltHousNumber,
    required this.street,
    required this.locality,
    required this.pincode,
    required this.latitude,
    required this.longitude,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
    id: json["id"],
    addressTypeId: json["addressTypeID"],
    addressType: json["addressType"],
    userId: json["userId"],
    addressTitle: json["addressTitle"],
    faltHousNumber: json["faltHousNumber"],
    street: json["street"],
    locality: json["locality"],
    pincode: json["pincode"],
    latitude: json["latitude"],
    longitude: json["longitude"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "addressTypeID": addressTypeId,
    "addressType": addressType,
    "userId": userId,
    "addressTitle": addressTitle,
    "faltHousNumber": faltHousNumber,
    "street": street,
    "locality": locality,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,
  };

  Map<String, String> toDisplayMap() {
    String typeName;
    switch (addressTypeId) {
      case 1:
        typeName = 'Home';
        break;
      case 2:
        typeName = 'Office';
        break;
      case 3:
        typeName = 'Workplace';
        break;
      case 4:
        typeName = 'Billing Address';
        break;
      case 5:
        typeName = 'Shipping Address';
        break;
      default:
        typeName = 'Unknown';
    }

    return {
      'title': addressTitle ?? "",
      'flat': faltHousNumber ?? "",
      'street': street,
      'locality': locality,
      'pincode': pincode,
      'type': typeName,
      'id': id.toString(),
      'addressTypeId': addressTypeId.toString(),
    };
  }
}