// lib/models/wishlist_response_model.dart

class WishlistResponseModel {
  final bool success;
  final String message;
  final int wishlistId;

  WishlistResponseModel({
    required this.success,
    required this.message,
    required this.wishlistId,
  });

  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) {
    return WishlistResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      wishlistId: json['wishlistId'] is int
          ? json['wishlistId'] as int
          : int.tryParse(json['wishlistId'].toString()) ?? 0,
    );
  }

  bool get isWished => wishlistId > 0 && success;
}