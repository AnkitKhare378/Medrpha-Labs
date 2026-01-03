// product_model.dart

class GetMedicineByCompanyModel1 {
  final int? id;
  final int? medicineId;
  final dynamic medicine; // Can be null, better to use dynamic or specify if it's always null/String/Object
  final int? companyId;
  final dynamic company; // Can be null, better to use dynamic or specify if it's always null/String/Object
  final double? mrpPrice;
  final double? salePrice;
  final DateTime? expiry;
  final String? product;
  final String? createdBy;
  final DateTime? createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;

  GetMedicineByCompanyModel1({
    this.id,
    this.medicineId,
    this.medicine,
    this.companyId,
    this.company,
    this.mrpPrice,
    this.salePrice,
    this.expiry,
    this.product,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  // Factory constructor for creating a ProductModel instance from a JSON map
  factory GetMedicineByCompanyModel1.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse potential numeric types to double
    double? _parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    // Helper function to safely parse date strings to DateTime
    DateTime? _parseDate(String? dateString) {
      if (dateString == null) return null;
      return DateTime.tryParse(dateString);
    }

    return GetMedicineByCompanyModel1(
      id: json['id'] as int?,
      medicineId: json['medicineId'] as int?,
      medicine: json['medicine'],
      companyId: json['companyId'] as int?,
      company: json['company'],
      mrpPrice: _parseDouble(json['mrpPrice']),
      salePrice: _parseDouble(json['salePrice']),
      expiry: _parseDate(json['expiry'] as String?),
      product: json['product'] as String?,
      createdBy: json['created_by'] as String?,
      createdDate: _parseDate(json['created_date'] as String?),
      modifiedBy: json['modified_by'] as String?,
      modifiedDate: _parseDate(json['modified_date'] as String?),
    );
  }

  // Method to convert the ProductModel instance back into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineId': medicineId,
      'medicine': medicine,
      'companyId': companyId,
      'company': company,
      'mrpPrice': mrpPrice,
      'salePrice': salePrice,
      'expiry': expiry?.toIso8601String(),
      'product': product,
      'created_by': createdBy,
      'created_date': createdDate?.toIso8601String(),
      'modified_by': modifiedBy,
      'modified_date': modifiedDate?.toIso8601String(),
    };
  }
}