class FamilyMemberModel {
  final int id;
  final String userId;
  final String firstName;
  final String lastName;
  final int age;
  final int relationId;
  final String gender;
  final DateTime dateOfBirth;
  final double heightCM;
  final double weightKG;
  final String? bloodGroup;
  final String address;
  final String? uploadPhoto;
  final dynamic relationMaster;

  FamilyMemberModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.relationId,
    required this.gender,
    required this.dateOfBirth,
    required this.heightCM,
    required this.weightKG,
    required this.address,
    this.bloodGroup,
    this.uploadPhoto,
    this.relationMaster,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id'] ?? 0,
      userId: json['userId']?.toString() ?? '', // Safety for String/Int
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      age: json['age'] ?? 0,
      relationId: json['relationId'] ?? 0,
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : DateTime.now(),
      // Use .toDouble() because API sends 0.00 which might be parsed as int or double
      heightCM: (json['heightCM'] ?? 0.0).toDouble(),
      weightKG: (json['weightKG'] ?? 0.0).toDouble(),
      // Fix: Address is NULL in your log, so handle it safely
      address: json['address']?.toString() ?? 'No address provided',
      bloodGroup: json['bloodGroup']?.toString(),
      uploadPhoto: json['uploadPhoto']?.toString(),
      relationMaster: json['relationMaster'],
    );
  }
}