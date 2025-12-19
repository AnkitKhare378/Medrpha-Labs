import 'package:equatable/equatable.dart';

class RatingDetailModel extends Equatable {
  final int id;
  final double ratingpoint;
  final String remark;
  final String userName;
  final DateTime createdDate;
  final String createdBy;
  final int productId;
  final int categoryId;

  const RatingDetailModel({
    required this.id,
    required this.ratingpoint,
    required this.remark,
    required this.userName,
    required this.createdDate,
    required this.createdBy,
    required this.productId,
    required this.categoryId,
  });

  factory RatingDetailModel.fromJson(Map<String, dynamic> json) {
    return RatingDetailModel(
      id: json['id'] as int? ?? 0,
      ratingpoint: json['ratingpoint'] as double? ?? 0.0,
      remark: json['remark'] as String? ?? 'No remark provided',
      userName: json['userName'] as String? ?? 'Anonymous',
      // Safely parse the DateTime string
      createdDate: DateTime.tryParse(json['created_date'] as String? ?? '') ?? DateTime.now(),
      createdBy: json['created_by'] as String? ?? '',
      productId: json['productId'] as int? ?? 0,
      categoryId: json['categoryId'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    id,
    ratingpoint,
    remark,
    userName,
    createdDate,
    createdBy,
    productId,
    categoryId,
  ];
}