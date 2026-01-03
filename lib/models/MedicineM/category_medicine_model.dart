class CategoryMedicineModel {
  final int? id;
  final String? name;
  final String? saltName;
  final int? categorysId;
  final String? strength;
  final String? description;
  final bool? isPrescription;

  CategoryMedicineModel({
    this.id,
    this.name,
    this.saltName,
    this.categorysId,
    this.strength,
    this.description,
    this.isPrescription,
  });

  factory CategoryMedicineModel.fromJson(Map<String, dynamic> json) {
    return CategoryMedicineModel(
      id: json['id'],
      name: json['name'],
      saltName: json['saltName'],
      categorysId: json['categorysId'],
      strength: json['strength'],
      description: json['description'],
      isPrescription: json['isPrescription'],
    );
  }
}