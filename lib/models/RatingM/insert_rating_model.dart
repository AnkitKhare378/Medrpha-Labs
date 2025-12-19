import 'package:equatable/equatable.dart';

// --- API Request Model ---
// This model maps directly to the raw body structure required by the API.
class InsertRatingRequest extends Equatable {
  final String remark;
  final int ratingpoint;
  final int userId;
  final int categoryId;
  final int productId;

  const InsertRatingRequest({
    required this.remark,
    required this.ratingpoint,
    required this.userId,
    required this.categoryId,
    required this.productId,
  });

  // Convert the model instance to a JSON map for the API request body.
  Map<String, dynamic> toJson() {
    return {
      'remark': remark,
      'ratingpoint': ratingpoint,
      'userId': userId,
      'categoryId': categoryId,
      'productId': productId,
    };
  }

  @override
  List<Object?> get props => [remark, ratingpoint, userId, categoryId, productId];
}

// --- API Response Model ---
// This model parses the successful response from the API.
class InsertRatingResponse extends Equatable {
  final int data;
  final String message;
  final bool succeeded;

  const InsertRatingResponse({
    required this.data,
    required this.message,
    required this.succeeded,
  });

  // Factory method to create an instance from a JSON map.
  factory InsertRatingResponse.fromJson(Map<String, dynamic> json) {
    return InsertRatingResponse(
      // The 'data' field might be an int or a String depending on the API's consistency.
      // We safely cast it to int.
      data: json['data'] as int? ?? 0,
      message: json['message'] as String? ?? 'Rating Added',
      succeeded: json['succeeded'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [data, message, succeeded];
}