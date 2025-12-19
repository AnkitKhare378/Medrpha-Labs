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
      id: json['id'] as int,
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: json['age'] as int,
      relationId: json['relationId'] as int,
      gender: json['gender'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      heightCM: json['heightCM'] as double,
      weightKG: json['weightKG'] as double,
      address: json['address'] as String,
      bloodGroup: json['bloodGroup'] as String?,
      uploadPhoto: json['uploadPhoto'] as String?,
      relationMaster: json['relationMaster'],
    );
  }
}