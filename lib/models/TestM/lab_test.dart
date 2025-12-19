// 1. New Model for the nested object
class TestSynonym {
  final int id;
  final String name;
  final String? created_by;
  final DateTime created_date;
  final String? modified_by;
  final DateTime? modified_date;

  TestSynonym({
    required this.id,
    required this.name,
    this.created_by,
    required this.created_date,
    this.modified_by,
    this.modified_date,
  });

  factory TestSynonym.fromJson(Map<String, dynamic> json) {
    return TestSynonym(
      id: json['id'] as int,
      name: json['name'] as String,
      created_by: json['created_by'] as String?,
      created_date: DateTime.parse(json['created_date'] as String),
      modified_by: json['modified_by'] as String?,
      modified_date: (json['modified_date'] != null && json['modified_date'] != "0001-01-01T00:00:00")
          ? DateTime.parse(json['modified_date'] as String)
          : null,
    );
  }
}

// 2. Updated LabTest Model
class LabTest {
  final int testID;
  final String testCode;
  final String testName;
  final int categoryID;
  final int departmentID;
  final int sampleTypeID;
  final int methodID;

  // 👇 Added field
  final int testSynonymId;
  // 👇 Added field
  final TestSynonym? testSynonym;

  final int unitID;
  final int reportFormatID;
  final String? normalRange;
  final double testPrice;
  final String? description;
  final bool isPopular;
  final int displayOrder;
  final bool isActive;
  final bool isfasting;
  final int companyId;
  final int labId;
  final String testImage;
  final int? symptomId;
  final String? created_by;
  final DateTime created_date;
  final String? modified_by;
  final DateTime? modified_date;

  LabTest({
    required this.testID,
    required this.testCode,
    required this.testName,
    required this.categoryID,
    required this.departmentID,
    required this.sampleTypeID,
    required this.methodID,
    // 👇 Added
    required this.testSynonymId,
    this.testSynonym,
    required this.unitID,
    required this.reportFormatID,
    this.normalRange,
    required this.testPrice,
    this.description,
    required this.isPopular,
    required this.displayOrder,
    required this.isActive,
    required this.isfasting,
    required this.companyId,
    required this.labId,
    required this.testImage,
    this.symptomId,
    this.created_by,
    required this.created_date,
    this.modified_by,
    this.modified_date,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      testID: json['testID'] as int,
      testCode: json['testCode'] as String,
      testName: json['testName'] as String,
      categoryID: json['categoryID'] as int,
      departmentID: json['departmentID'] as int,
      sampleTypeID: json['sampleTypeID'] as int,
      methodID: json['methodID'] as int,

      // 👇 Added new fields
      testSynonymId: json['testSynonymId'] as int,
      testSynonym: json['testSynonym'] != null
          ? TestSynonym.fromJson(json['testSynonym'] as Map<String, dynamic>)
          : null,

      unitID: json['unitID'] as int,
      reportFormatID: json['reportFormatID'] as int,
      normalRange: json['normalRange'] as String?,
      testPrice: (json['testPrice'] as num).toDouble(),
      description: json['description'] as String?,
      isPopular: json['isPopular'] as bool,
      displayOrder: json['displayOrder'] as int,
      isActive: json['isActive'] as bool,
      isfasting: json['isfasting'] as bool,
      companyId: json['companyId'] as int,
      labId: json['labId'] as int,
      testImage: json['testImage'] as String,
      symptomId: json['symptomId'] as int?,
      created_by: json['created_by'] as String?,
      created_date: DateTime.parse(json['created_date'] as String),
      modified_by: json['modified_by'] as String?,
      modified_date: (json['modified_date'] != null && json['modified_date'] != "0001-01-01T00:00:00")
          ? DateTime.parse(json['modified_date'] as String)
          : null,
    );
  }

  // NOTE: Your toJson only includes a subset of fields.
  // I am leaving it as is, but typically all fields are included.
  Map<String, dynamic> toJson() {
    return {
      'testID': testID,
      'testCode': testCode,
      'testName': testName,
      'testPrice': testPrice,
    };
  }
}