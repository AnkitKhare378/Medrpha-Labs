class InsertFamilyMemberResponseModel {
  final int data;
  final List<String> messages;
  final String message;
  final bool succeeded;

  InsertFamilyMemberResponseModel({
    required this.data,
    required this.messages,
    required this.message,
    required this.succeeded,
  });

  /// Factory constructor to create an instance from the JSON response map.
  factory InsertFamilyMemberResponseModel.fromJson(Map<String, dynamic> json) {
    return InsertFamilyMemberResponseModel(
      // The API returns the new ID as 'data'
      data: json['data'] as int,

      // Handle the list of messages robustly
      messages: List<String>.from(json['messages'] ?? []),

      message: json['message'] as String,
      succeeded: json['succeeded'] as bool,
    );
  }
}
