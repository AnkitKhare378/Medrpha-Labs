// Path: lib/data/models/rating_update_model.dart

class RatingUpdateResponseModel {
  final dynamic data;
  final String message;
  final bool succeeded;
  final List<String> messages;

  RatingUpdateResponseModel({
    required this.data,
    required this.message,
    required this.succeeded,
    required this.messages,
  });

  factory RatingUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return RatingUpdateResponseModel(
      data: json['data'],
      message: json['message'] ?? '',
      succeeded: json['succeeded'] ?? false,
      messages: (json['messages'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
