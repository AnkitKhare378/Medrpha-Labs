import 'package:equatable/equatable.dart';

class TestDetailModel extends Equatable {
  final int testID;
  final String testCode;
  final String testName;
  final int categoryID;
  final String categoryName;
  final int departmentID;
  final String departmentName;
  final int sampleTypeID;
  final String sampleName;
  final int methodID;
  final String methodName;
  final int testSynonymId;
  final String? synonymName;
  final int unitID;
  final String unitName;
  final int reportFormatID;
  final String? reportFormatName;
  final String normalRange;
  final double testPrice; // Assuming it can be a double
  final String description;
  final bool isPopular;
  final int displayOrder;
  final bool isActive;
  final bool isFasting;
  final int companyId;
  final int labId;
  final String testImage;
  final int symptomId;

  const TestDetailModel({
    required this.testID,
    required this.testCode,
    required this.testName,
    required this.categoryID,
    required this.categoryName,
    required this.departmentID,
    required this.departmentName,
    required this.sampleTypeID,
    required this.sampleName,
    required this.methodID,
    required this.methodName,
    required this.testSynonymId,
    this.synonymName,
    required this.unitID,
    required this.unitName,
    required this.reportFormatID,
    this.reportFormatName,
    required this.normalRange,
    required this.testPrice,
    required this.description,
    required this.isPopular,
    required this.displayOrder,
    required this.isActive,
    required this.isFasting,
    required this.companyId,
    required this.labId,
    required this.testImage,
    required this.symptomId,
  });

  // Factory constructor to create a TestDetailModel from a JSON map
  factory TestDetailModel.fromJson(Map<String, dynamic> json) {
    return TestDetailModel(
      testID: json['testID'] as int,
      testCode: json['testCode'] as String,
      testName: json['testName'] as String,
      categoryID: json['categoryID'] as int,
      categoryName: json['categoryName'] as String,
      departmentID: json['departmentID'] as int,
      departmentName: json['departmentName'] as String,
      sampleTypeID: json['sampleTypeID'] as int,
      sampleName: json['sampleName'] as String,
      methodID: json['methodID'] as int,
      methodName: json['methodName'] as String,
      testSynonymId: json['testSynonymId'] as int,
      synonymName: json['synonymName'] as String?,
      unitID: json['unitID'] as int,
      unitName: json['unitName'] as String,
      reportFormatID: json['reportFormatID'] as int,
      reportFormatName: json['reportFormatName'] as String?,
      normalRange: json['normalRange'] as String,
      // Handle potential number types for price (int or double)
      testPrice: (json['testPrice'] as num).toDouble(),
      description: json['description'] as String,
      isPopular: json['isPopular'] as bool,
      displayOrder: json['displayOrder'] as int,
      isActive: json['isActive'] as bool,
      isFasting: json['isFasting'] as bool,
      companyId: json['companyId'] as int,
      labId: json['labId'] as int,
      testImage: json['testImage'] as String,
      symptomId: json['symptomId'] as int,
    );
  }

  @override
  List<Object?> get props => [
    testID,
    testCode,
    testName,
    categoryID,
    departmentID,
    sampleTypeID,
    unitID,
    reportFormatID,
    normalRange,
    testPrice,
    description,
    isPopular,
    isFasting,
    testImage,
  ];
}