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
      // Use ?? to provide a default value if the key is null
      testID: json['testID'] as int? ?? 0,
      testCode: json['testCode'] as String? ?? '',
      testName: json['testName'] as String? ?? 'Unknown Test',
      categoryID: json['categoryID'] as int? ?? 0,
      categoryName: json['categoryName'] as String? ?? '',
      departmentID: json['departmentID'] as int? ?? 0,
      departmentName: json['departmentName'] as String? ?? '',
      sampleTypeID: json['sampleTypeID'] as int? ?? 0,
      sampleName: json['sampleName'] as String? ?? '',
      methodID: json['methodID'] as int? ?? 0,
      methodName: json['methodName'] as String? ?? '',
      testSynonymId: json['testSynonymId'] as int? ?? 0,
      synonymName: json['synonymName'] as String?, // Already nullable
      unitID: json['unitID'] as int? ?? 0,
      unitName: json['unitName'] as String? ?? '',
      reportFormatID: json['reportFormatID'] as int? ?? 0,
      reportFormatName: json['reportFormatName'] as String?, // Already nullable
      normalRange: json['normalRange'] as String? ?? 'N/A',

      // Safety for numbers: cast as num first, then toDouble
      testPrice: (json['testPrice'] as num? ?? 0.0).toDouble(),

      description: json['description'] as String? ?? '',
      isPopular: json['isPopular'] as bool? ?? false,
      displayOrder: json['displayOrder'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      isFasting: json['isFasting'] as bool? ?? false,
      companyId: json['companyId'] as int? ?? 0,
      labId: json['labId'] as int? ?? 0,
      testImage: json['testImage'] as String? ?? '',
      symptomId: json['symptomId'] as int? ?? 0,
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