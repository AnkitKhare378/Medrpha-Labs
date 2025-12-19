// lib/models/AddressM/delete_address_model.dart

class DeleteAddressModel {
  final int? data;
  final List<String> messages;
  final String message;
  final bool succeeded;
  final int totalCount;
  final int totalPages;

  DeleteAddressModel({
    this.data,
    required this.messages,
    required this.message,
    required this.succeeded,
    required this.totalCount,
    required this.totalPages,
  });

  factory DeleteAddressModel.fromJson(Map<String, dynamic> json) {
    return DeleteAddressModel(
      data: json['data'] as int?,
      messages: (json['messages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      message: json['message'] as String? ?? '',
      succeeded: json['succeeded'] as bool? ?? false,
      totalCount: json['totalCount'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'messages': messages,
      'message': message,
      'succeeded': succeeded,
      'totalCount': totalCount,
      'totalPages': totalPages,
    };
  }
}