// File: lib/models/FaqM/get_frequently_model.dart

class FrequentlyModel {
  final int id;
  final String question; // Mapped from 'qusetion' in API
  final String answer;
  final bool isActive;
  final String createdBy;
  final DateTime createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;

  FrequentlyModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.isActive,
    required this.createdBy,
    required this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory FrequentlyModel.fromJson(Map<String, dynamic> json) {
    return FrequentlyModel(
      id: json['id'] as int,
      // Note the API spelling 'qusetion' is mapped to 'question' here
      question: json['qusetion'] as String,
      answer: json['answer'] as String,
      isActive: json['isActive'] as bool,
      createdBy: json['created_by'] as String,
      createdDate: DateTime.parse(json['created_date'] as String),
      modifiedBy: json['modified_by'] as String?,
      modifiedDate: json['modified_date'] != null && json['modified_date'] != "0001-01-01T00:00:00"
          ? DateTime.parse(json['modified_date'] as String)
          : null,
    );
  }
}