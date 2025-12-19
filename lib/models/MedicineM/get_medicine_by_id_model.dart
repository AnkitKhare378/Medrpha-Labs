class GetMedicineByIdModel {
  final int id;
  final int medicineId;
  // medicine is null in response, kept nullable
  final String? medicine;
  final int companyId;
  // company is null in response, kept nullable
  final String? company;
  final double mrpPrice;
  final double salePrice;
  final DateTime expiry;
  final String product;
  final String createdBy;
  final DateTime createdDate;
  // modifiedBy is null in response, kept nullable
  final String? modifiedBy;
  // modifiedDate is null in response, kept nullable
  final DateTime? modifiedDate;

  GetMedicineByIdModel({
    required this.id,
    required this.medicineId,
    this.medicine,
    required this.companyId,
    this.company,
    required this.mrpPrice,
    required this.salePrice,
    required this.expiry,
    required this.product,
    required this.createdBy,
    required this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory GetMedicineByIdModel.fromJson(Map<String, dynamic> json) {
    return GetMedicineByIdModel(
      id: json['id'] as int,
      medicineId: json['medicineId'] as int,
      medicine: json['medicine'] as String?,
      companyId: json['companyId'] as int,
      company: json['company'] as String?,
      // Use null-aware operator for potential null values and cast to double
      mrpPrice: (json['mrpPrice'] as num).toDouble(),
      salePrice: (json['salePrice'] as num).toDouble(),
      expiry: DateTime.parse(json['expiry'] as String),
      product: json['product'] as String,
      createdBy: json['created_by'] as String,
      createdDate: DateTime.parse(json['created_date'] as String),
      modifiedBy: json['modified_by'] as String?,
      // Handle the "0001-01-01T00:00:00" case as null
      modifiedDate: (json['modified_date'] as String?) == '0001-01-01T00:00:00'
          ? null
          : DateTime.tryParse(json['modified_date'] as String? ?? ''),
    );
  }
}