class AddToCartResponse {
  final bool succeeded;
  final String message;
  final int? dataId;

  AddToCartResponse({
    required this.succeeded,
    required this.message,
    this.dataId,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    // Determine the primary message source: 'messages' list first, then 'message' string
    String finalMessage = (json['messages'] as List<dynamic>?)?.isNotEmpty == true
        ? json['messages'][0] as String
        : json['message'] as String? ?? 'Operation failed.';

    // Attempt to parse 'data' as an integer
    int? dataValue;
    if (json['data'] is int) {
      dataValue = json['data'] as int;
    } else if (json['data'] is String) {
      // Handle cases where the API might return "5" instead of 5
      dataValue = int.tryParse(json['data'] as String);
    }

    return AddToCartResponse(
      succeeded: json['succeeded'] as bool? ?? false,
      message: finalMessage,
      dataId: dataValue, // Assign the parsed ID
    );
  }
}


class AddCartItem {
  final int productId;
  final int categoryId;
  final int quantity;
  final double price;
  final double discount;

  AddCartItem({
    required this.productId,
    required this.categoryId,
    required this.quantity,
    required this.price,
    required this.discount,
  });
}
