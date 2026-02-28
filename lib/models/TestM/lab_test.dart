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
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      created_by: json['created_by']?.toString(),
      created_date: json['created_date'] != null
          ? DateTime.parse(json['created_date'] as String)
          : DateTime.now(),
      modified_by: json['modified_by']?.toString(),
      modified_date: (json['modified_date'] != null && json['modified_date'] != "0001-01-01T00:00:00")
          ? DateTime.parse(json['modified_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_by': created_by,
      'created_date': created_date.toIso8601String(),
      'modified_by': modified_by,
      'modified_date': modified_date?.toIso8601String(),
    };
  }
}

class LabTest {
  final int testID;
  final String testCode;
  final String testName;
  final int categoryID;
  final int departmentID;
  final int sampleTypeID;
  final int methodID;
  final int testSynonymId;
  final TestSynonym? testSynonym;
  final int unitID;
  final int reportFormatID;
  final String? normalRange;
  final double testPrice;
  final double sellingPrice;
  final double discount;
  final String? description;
  final bool isPopular;
  final int displayOrder;
  final bool isActive;
  final bool isfasting;
  final int companyId;
  final int labId;
  final Lab? lab;
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
    required this.testSynonymId,
    this.testSynonym,
    required this.unitID,
    required this.reportFormatID,
    this.normalRange,
    required this.testPrice,
    required this.sellingPrice,
    required this.discount,
    this.description,
    required this.isPopular,
    required this.displayOrder,
    required this.isActive,
    required this.isfasting,
    required this.companyId,
    required this.labId,
    this.lab,
    required this.testImage,
    this.symptomId,
    this.created_by,
    required this.created_date,
    this.modified_by,
    this.modified_date,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      testID: json['testID'] as int? ?? 0,
      testCode: json['testCode']?.toString() ?? '',
      testName: json['testName']?.toString() ?? '',
      categoryID: json['categoryID'] as int? ?? 0,
      departmentID: json['departmentID'] as int? ?? 0,
      sampleTypeID: json['sampleTypeID'] as int? ?? 0,
      methodID: json['methodID'] as int? ?? 0,
      testSynonymId: json['testSynonymId'] as int? ?? 0,
      testSynonym: json['testSynonym'] != null
          ? TestSynonym.fromJson(json['testSynonym'] as Map<String, dynamic>)
          : null,
      unitID: json['unitID'] as int? ?? 0,
      reportFormatID: json['reportFormatID'] as int? ?? 0,
      normalRange: json['normalRange']?.toString(),
      testPrice: (json['testPrice'] as num? ?? 0.0).toDouble(),
      sellingPrice: (json['sellingPrice'] as num? ?? 0.0).toDouble(),
      discount: (json['discount'] as num? ?? 0.0).toDouble(),
      description: json['description']?.toString(),
      isPopular: json['isPopular'] as bool? ?? false,
      displayOrder: json['displayOrder'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      isfasting: json['isfasting'] as bool? ?? false,
      companyId: json['companyId'] as int? ?? 0,
      labId: json['labId'] as int? ?? 0,
      lab: json['lab'] != null ? Lab.fromJson(json['lab'] as Map<String, dynamic>) : null,
      testImage: json['testImage']?.toString() ?? '',
      symptomId: json['symptomId'] as int?,
      created_by: json['created_by']?.toString(),
      created_date: json['created_date'] != null
          ? DateTime.parse(json['created_date'] as String)
          : DateTime.now(),
      modified_by: json['modified_by']?.toString(),
      modified_date: (json['modified_date'] != null && json['modified_date'] != "0001-01-01T00:00:00")
          ? DateTime.parse(json['modified_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testID': testID,
      'testCode': testCode,
      'testName': testName,
      'testPrice': testPrice,
      'sellingPrice': sellingPrice,
      'discount': discount,
      'lab': lab?.toJson(),
      'testSynonym': testSynonym?.toJson(),
    };
  }
}

class Lab {
  final int id;
  final String labName;
  final String email;
  final String phoneNo;
  final String? address;
  final String? labImage;
  final String? latitude;
  final String? longitude;

  Lab({
    required this.id,
    required this.labName,
    required this.email,
    required this.phoneNo,
    this.address,
    this.labImage,
    this.latitude,
    this.longitude,
  });

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      id: json['id'] as int? ?? 0,
      labName: json['lab_name']?.toString() ?? 'Unnamed Lab',
      email: json['email']?.toString() ?? '',
      phoneNo: json['phone_no']?.toString() ?? '',
      address: json['address']?.toString(),
      labImage: json['lab_image']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longnitude']?.toString(), // Handle API typo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lab_name': labName,
      'email': email,
      'phone_no': phoneNo,
      'address': address,
      'lab_image': labImage,
      'latitude': latitude,
      'longnitude': longitude,
    };
  }
}