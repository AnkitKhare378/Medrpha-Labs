class RatingDeleteResponseModel {
  final int data;
  final List<String> messages;
  final String? message;
  final bool succeeded;
  final int totalCount;
  final int totalPages;

  RatingDeleteResponseModel({
    required this.data,
    required this.messages,
    this.message,
    required this.succeeded,
    required this.totalCount,
    required this.totalPages,
  });

  factory RatingDeleteResponseModel.fromJson(Map<String, dynamic> json) {
    return RatingDeleteResponseModel(
      data: json['data'] as int? ?? 0,
      messages: List<String>.from(json['messages'] as List? ?? []),
      message: json['message'] as String?,
      succeeded: json['succeeded'] as bool? ?? false,
      totalCount: json['totalCount'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}