// lib/models/SymptomM/symptom_model.dart
import 'dart:convert';

List<SymptomModel> symptomModelFromJson(String str) =>
    List<SymptomModel>.from(json.decode(str).map((x) => SymptomModel.fromJson(x)));

String symptomModelToJson(List<SymptomModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SymptomModel {
  final int id;
  final String name;
  final bool isactive;
  final String? symptomsImage;
  final String? createdBy;
  final DateTime? createdDate;
  final dynamic modifiedBy;
  final DateTime? modifiedDate;

  SymptomModel({
    required this.id,
    required this.name,
    required this.isactive,
    this.symptomsImage,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory SymptomModel.fromJson(Map<String, dynamic> json) => SymptomModel(
    id: json["id"],
    name: json["name"] ?? "Unknown Symptom",
    isactive: json["isactive"] ?? false,
    symptomsImage: json["symptoms_Image"],
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
    "name": name,
    "isactive": isactive,
    "symptoms_Image": symptomsImage,
    "created_by": createdBy,
    "created_date": createdDate?.toIso8601String(),
    "modified_by": modifiedBy,
    "modified_date": modifiedDate?.toIso8601String(),
  };
}