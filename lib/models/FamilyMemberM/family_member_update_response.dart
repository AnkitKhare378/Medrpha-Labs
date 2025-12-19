// File: lib/models/FamilyMemberM/family_member_update_response.dart

class FamilyMemberUpdateResponse {
  final int data;
  final String message;
  final bool succeeded;

  FamilyMemberUpdateResponse({
    required this.data,
    required this.message,
    required this.succeeded,
  });

  factory FamilyMemberUpdateResponse.fromJson(Map<String, dynamic> json) {
    // Assuming 'message' is the primary status message, even if 'messages' is an array.
    final List<dynamic> messagesList = json['messages'] ?? [];
    final message = messagesList.isNotEmpty ? messagesList.first.toString() : (json['message'] as String? ?? 'Operation completed.');

    return FamilyMemberUpdateResponse(
      data: json['data'] as int? ?? 0,
      message: message,
      succeeded: json['succeeded'] as bool? ?? false,
    );
  }
}