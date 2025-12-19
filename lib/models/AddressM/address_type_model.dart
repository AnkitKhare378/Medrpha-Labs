// lib/models/AddressM/address_type_model.dart
class AddressTypeModel {
  final int id;
  final String name;

  AddressTypeModel({
    required this.id,
    required this.name,
  });

  factory AddressTypeModel.fromJson(Map<String, dynamic> json) {
    return AddressTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  static List<AddressTypeModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => AddressTypeModel.fromJson(e)).toList();
  }
}
