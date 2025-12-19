// lib/models/lab_model.dart
import 'dart:convert';

List<LabModel> labModelFromJson(String str) =>
    List<LabModel>.from(json.decode(str).map((x) => LabModel.fromJson(x)));

String labModelToJson(List<LabModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LabModel {
  final int id;
  final String labName;
  final String? email;
  final String? phoneNo;
  final int? companyId;
  final dynamic company;
  final String? externalUrl;
  final String? longnitude;
  final String? latitude;
  final String? address; // Added
  final String? officeNo; // Added
  final bool? isActive;
  final bool? isLab; // Added
  final bool? isMedicineStore; // Added
  final String? description;
  final String? labImage;
  final String? createdBy;
  final DateTime? createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;

  LabModel({
    required this.id,
    required this.labName,
    this.email,
    this.phoneNo,
    this.companyId,
    this.company,
    this.externalUrl,
    this.longnitude,
    this.latitude,
    this.address,
    this.officeNo,
    this.isActive,
    this.isLab,
    this.isMedicineStore,
    this.description,
    this.labImage,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory LabModel.fromJson(Map<String, dynamic> json) => LabModel(
    id: json["id"],
    labName: json["lab_name"] ?? "Unknown Lab",
    email: json["email"],
    phoneNo: json["phone_no"],
    companyId: json["company_Id"],
    company: json["company"],
    externalUrl: json["externalUrl"],
    longnitude: json["longnitude"],
    latitude: json["latitude"],
    address: json["address"],
    officeNo: json["officeNo"],
    isActive: json["isActive"],
    isLab: json["isLab"],
    isMedicineStore: json["isMedicineStore"],
    description: json["description"],
    labImage: json["lab_image"],
    createdBy: json["created_by"],
    createdDate: json["created_date"] != null
        ? DateTime.parse(json["created_date"])
        : null,
    modifiedBy: json["modified_by"],
    modifiedDate: json["modified_date"] != null &&
        json["modified_date"] != "0001-01-01T00:00:00"
        ? DateTime.parse(json["modified_date"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lab_name": labName,
    "email": email,
    "phone_no": phoneNo,
    "company_Id": companyId,
    "company": company,
    "externalUrl": externalUrl,
    "longnitude": longnitude,
    "latitude": latitude,
    "address": address,
    "officeNo": officeNo,
    "isActive": isActive,
    "isLab": isLab,
    "isMedicineStore": isMedicineStore,
    "description": description,
    "lab_image": labImage,
    "created_by": createdBy,
    "created_date": createdDate?.toIso8601String(),
    "modified_by": modifiedBy,
    "modified_date": modifiedDate?.toIso8601String(),
  };
}