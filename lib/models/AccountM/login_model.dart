// lib/model/login_model.dart
class LoginModel {
  final dynamic data;
  final List<String>? messages;
  final String? message;
  final bool succeeded;

  LoginModel({
    this.data,
    this.messages,
    this.message,
    required this.succeeded,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      data: json['data'],
      messages: (json['messages'] as List?)?.map((e) => e.toString()).toList(),
      message: json['message'],
      succeeded: json['succeeded'] ?? false,
    );
  }
}
