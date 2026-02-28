// file: lib/models/CartM/delete_cart_model.dart

class DeleteCartResponse {
  final int? data;
  final List<String>? messages;
  final String? message;
  final bool succeeded;

  DeleteCartResponse({
    this.data,
    this.messages,
    this.message,
    required this.succeeded,
  });

  factory DeleteCartResponse.fromJson(Map<String, dynamic> json) {
    return DeleteCartResponse(
      data: json['data'],
      messages: json['messages'] != null ? List<String>.from(json['messages']) : null,
      message: json['message'],
      succeeded: json['succeeded'] ?? false,
    );
  }
}