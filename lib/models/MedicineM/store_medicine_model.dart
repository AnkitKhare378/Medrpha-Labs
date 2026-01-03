class StoreMedicineModel {
  final int? id;
  final int? medicineId;
  final String? medicine;
  final int? companyId;
  final double? mrpPrice;
  final double? salePrice;
  final DateTime? expiry;
  final String? product;
  final int? storeId;
  final String? image;

  StoreMedicineModel({
    this.id,
    this.medicineId,
    this.medicine,
    this.companyId,
    this.mrpPrice,
    this.salePrice,
    this.expiry,
    this.product,
    this.storeId,
    this.image,
  });

  factory StoreMedicineModel.fromJson(Map<String, dynamic> json) => StoreMedicineModel(
    id: json["id"],
    medicineId: json["medicineId"],
    medicine: json["medicine"],
    companyId: json["companyId"],
    mrpPrice: (json["mrpPrice"] as num?)?.toDouble(),
    salePrice: (json["salePrice"] as num?)?.toDouble(),
    expiry: json["expiry"] != null ? DateTime.parse(json["expiry"]) : null,
    product: json["product"],
    storeId: json["storeId"],
    image: json["image"],
  );
}