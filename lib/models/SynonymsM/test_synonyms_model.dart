import 'package:equatable/equatable.dart';

class TestSynonymModel extends Equatable {
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
  final String synonymName;
  final int unitID;
  final String unitName;
  final int reportFormatID;
  final String? reportFormatName;
  final String normalRange;
  final double testPrice;
  final String description;
  final bool isPopular;
  final int displayOrder;
  final bool isActive;
  final bool isFasting;
  final int companyId;
  final int labId;
  final String? testImage;
  final int symptomId;

  const TestSynonymModel({
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
    required this.synonymName,
    required this.unitID,
    required this.unitName,
    this.reportFormatName,
    required this.reportFormatID,
    required this.normalRange,
    required this.testPrice,
    required this.description,
    required this.isPopular,
    required this.displayOrder,
    required this.isActive,
    required this.isFasting,
    required this.companyId,
    required this.labId,
    this.testImage,
    required this.symptomId,
  });

  factory TestSynonymModel.fromJson(Map<String, dynamic> json) {
    return TestSynonymModel(
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
      synonymName: json['synonymName'] as String,
      unitID: json['unitID'] as int,
      unitName: json['unitName'] as String,
      reportFormatID: json['reportFormatID'] as int,
      reportFormatName: json['reportFormatName'] as String?,
      normalRange: json['normalRange'] as String,
      // API returns price as an int/double, cast to double
      testPrice: (json['testPrice'] as num).toDouble(),
      description: json['description'] as String,
      isPopular: json['isPopular'] as bool,
      displayOrder: json['displayOrder'] as int,
      isActive: json['isActive'] as bool,
      isFasting: json['isFasting'] as bool,
      companyId: json['companyId'] as int,
      labId: json['labId'] as int,
      testImage: json['testImage'] as String?,
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
    synonymName,
    testPrice,
    description,
  ];
}