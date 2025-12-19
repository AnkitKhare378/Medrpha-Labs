class FamilyMemberDeleteModel {
  final int? data;
  final List<String> messages;
  final String message;
  final bool succeeded;
  final int totalCount;
  final int totalPages;

  FamilyMemberDeleteModel({
    this.data,
    required this.messages,
    required this.message,
    required this.succeeded,
    required this.totalCount,
    required this.totalPages,
  });

  factory FamilyMemberDeleteModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberDeleteModel(
      data: json['data'] as int?,
      messages: (json['messages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      message: json['message'] as String,
      succeeded: json['succeeded'] as bool,
      totalCount: json['totalCount'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}