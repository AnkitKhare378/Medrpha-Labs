class RelationModel {
  final int id;
  final String relationName;
  final bool isActive;

  RelationModel({
    required this.id,
    required this.relationName,
    required this.isActive,
  });

  factory RelationModel.fromJson(Map<String, dynamic> json) {
    return RelationModel(
      id: json['id'] as int,
      relationName: json['relationName'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}