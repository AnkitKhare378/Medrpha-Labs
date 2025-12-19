// get_all_banner_model.dart

import 'dart:convert';

/// Converts a JSON string to a list of [GetAllBannerModel].
List<GetAllBannerModel> getAllBannerModelFromJson(String str) =>
    List<GetAllBannerModel>.from(
        json.decode(str).map((x) => GetAllBannerModel.fromJson(x)));

/// Converts a list of [GetAllBannerModel] to a JSON string.
String getAllBannerModelToJson(List<GetAllBannerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllBannerModel {
  final int? id;
  final int? bannerCategoryId;
  final int? productCategoryId;
  final int? companyId;
  final int? labId;
  final DateTime? startDate;
  final dynamic endDate; // Can be null
  final bool? isActive;
  final String? image;
  final String? createdBy;
  final DateTime? createdDate;
  final dynamic modifiedBy; // Can be null
  final dynamic modifiedDate; // Can be null

  GetAllBannerModel({
    this.id,
    this.bannerCategoryId,
    this.productCategoryId,
    this.companyId,
    this.labId,
    this.startDate,
    this.endDate,
    this.isActive,
    this.image,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  /// Factory constructor to create a [GetAllBannerModel] from a JSON map.
  factory GetAllBannerModel.fromJson(Map<String, dynamic> json) =>
      GetAllBannerModel(
        id: json["id"],
        bannerCategoryId: json["bannerCategoryId"],
        productCategoryId: json["productCategoryId"],
        companyId: json["companyId"],
        labId: json["labId"],
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : null,
        endDate: json["endDate"],
        isActive: json["isActive"],
        image: json["image"],
        createdBy: json["created_by"],
        createdDate: json["created_date"] != null
            ? DateTime.parse(json["created_date"])
            : null,
        modifiedBy: json["modified_by"],
        modifiedDate: json["modified_date"],
      );

  /// Converts the [GetAllBannerModel] to a JSON map.
  Map<String, dynamic> toJson() => {
    "id": id,
    "bannerCategoryId": bannerCategoryId,
    "productCategoryId": productCategoryId,
    "companyId": companyId,
    "labId": labId,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate,
    "isActive": isActive,
    "image": image,
    "created_by": createdBy,
    "created_date": createdDate?.toIso8601String(),
    "modified_by": modifiedBy,
    "modified_date": modifiedDate,
  };
}