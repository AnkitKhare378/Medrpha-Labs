// lib/models/BloodM/get_blood_model.dart

class GetBloodGroupModel {
  final int id;
  final String name;

  GetBloodGroupModel({required this.id, required this.name});

  factory GetBloodGroupModel.fromJson(Map<String, dynamic> json) {
    return GetBloodGroupModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  // Helper method for display
  @override
  String toString() => 'BloodGroup(id: $id, name: $name)';
}