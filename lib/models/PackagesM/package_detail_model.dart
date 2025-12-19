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
    // 1. Decode the stringified JSON array
    final List<dynamic> testsJson =
    jsonDecode(json['testPackageDetailsJson'] as String);

    // 2. Map the dynamic list to a list of PackageTestDetail objects
    final List<PackageTestDetail> packageTests = testsJson
        .map((testJson) => PackageTestDetail.fromJson(testJson as Map<String, dynamic>))
        .toList();

    return PackageDetailModel(
      packageId: json['packageId'] as int,
      packageName: json['packageName'] as String,
      description: json['description'] as String,
      packagePrice: (json['packagePrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num).toDouble(),
      packageImage: json['packageImage'] as String?,
      isPopular: json['isPopular'] as bool,
      isActive: json['isActive'] as bool,
      isFasting: json['isFasting'] as bool,
      companyId: json['companyId'] as int,
      companyName: json['companyName'] as String?,
      labId: json['labId'] as int,
      labName: json['labName'] as String?,
      packageTests: packageTests,
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