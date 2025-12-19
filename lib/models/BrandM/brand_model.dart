class BrandModel {
  final int id;
  final String brandName;
  final String image;
  final bool isPop;
  final bool isActive;
  final String? createdBy;
  final DateTime createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;

  BrandModel({
    required this.id,
    required this.brandName,
    required this.image,
    required this.isPop,
    required this.isActive,
    required this.createdDate,
    this.createdBy,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as int,
      brandName: json['brandName'] as String,
      image: json['image'] as String,
      isPop: json['isPop'] as bool,
      isActive: json['isActive'] as bool,
      createdDate: DateTime.parse(json['created_Date'] as String),
      createdBy: json['created_By'] as String?,
      modifiedBy: json['modified_By'] as String?,
      modifiedDate: json['modified_Date'] != null
          ? DateTime.parse(json['modified_Date'] as String)
          : null,
    );
  }
}