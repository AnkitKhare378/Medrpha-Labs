class OrderResponseModel {
  final int? data;
  final String? message;
  final bool succeeded;
  final String? orderNumber;

  OrderResponseModel({
    this.data,
    this.message,
    required this.succeeded,
    this.orderNumber,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    String fullMessage = json['message'] ?? (json['messages']?.isNotEmpty == true ? json['messages'][0] : null);
    String? orderNumber;

    if (fullMessage != null) {
      final RegExp orderNumRegex = RegExp(r"Order No: (ORD-\d{4}-\d{4})");
      final match = orderNumRegex.firstMatch(fullMessage);
      orderNumber = match?.group(1);
    }

    return OrderResponseModel(
      data: json['data'] as int?,
      message: fullMessage,
      succeeded: json['succeeded'] as bool? ?? false,
      orderNumber: orderNumber,
    );
  }
}