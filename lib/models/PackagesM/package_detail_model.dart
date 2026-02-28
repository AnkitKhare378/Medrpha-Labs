import 'dart:convert';
import 'package:equatable/equatable.dart';

class PackageTestDetail extends Equatable {
  final int id;
  final int packageId;
  final int testId;
  final String testName;
  final double testPriceInPackage;

  const PackageTestDetail({
    required this.id,
    required this.packageId,
    required this.testId,
    required this.testName,
    required this.testPriceInPackage,
  });

  factory PackageTestDetail.fromJson(Map<String, dynamic> json) {
    return PackageTestDetail(
      id: json['Id'] as int,
      packageId: json['PackageId'] as int,
      testId: json['TestId'] as int,
      testName: json['TestName'] as String,
      // Handle potential number types for price
      testPriceInPackage: (json['TestPriceInPackage'] as num).toDouble(),
    );
  }

  @override
  List<Object> get props => [id, packageId, testId, testName, testPriceInPackage];
}

// Main model for the package details
class PackageDetailModel extends Equatable {
  final int packageId;
  final String packageName;
  final String description;
  final double packagePrice;
  final double totalPrice;
  final double discountPrice;
  final String? packageImage;
  final bool isPopular;
  final bool isActive;
  final bool isFasting;
  final int companyId;
  final String? companyName;
  final int labId;
  final String? labName;
  final List<PackageTestDetail> packageTests;

  const PackageDetailModel({
    required this.packageId,
    required this.packageName,
    required this.description,
    required this.packagePrice,
    required this.totalPrice,
    required this.discountPrice,
    this.packageImage,
    required this.isPopular,
    required this.isActive,
    required this.isFasting,
    required this.companyId,
    this.companyName,
    required this.labId,
    this.labName,
    required this.packageTests,
  });

  factory PackageDetailModel.fromJson(Map<String, dynamic> json) {
    // 1. Safe check for the stringified JSON array
    final String? testJsonString = json['testPackageDetailsJson'] as String?;

    List<PackageTestDetail> packageTests = [];

    if (testJsonString != null && testJsonString.isNotEmpty) {
      final List<dynamic> testsJson = jsonDecode(testJsonString);
      packageTests = testsJson
          .map((testJson) => PackageTestDetail.fromJson(testJson as Map<String, dynamic>))
          .toList();
    }

    return PackageDetailModel(
      packageId: json['packageId'] as int? ?? 0,
      packageName: json['packageName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      packagePrice: (json['packagePrice'] as num? ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] as num? ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] as num? ?? 0).toDouble(),
      packageImage: json['packageImage'] as String?,
      isPopular: json['isPopular'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? false,
      isFasting: json['isFasting'] as bool? ?? false,
      companyId: json['companyId'] as int? ?? 0,
      companyName: json['companyName'] as String?,
      labId: json['labId'] as int? ?? 0,
      labName: json['labName'] as String?,
      packageTests: packageTests, // This will be empty if JSON was null
    );
  }


  @override
  List<Object?> get props => [
    packageId,
    packageName,
    description,
    packagePrice,
    totalPrice,
    discountPrice,
    isFasting,
    packageTests,
  ];
}