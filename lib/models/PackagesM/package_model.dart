class PackageModel {
  final int packageId;
  final String packageName;
  final double packagePrice;
  final double discountPrice;
  final List<TestDetailModel> details;
  final int labId;

  PackageModel({
    required this.packageId,
    required this.packageName,
    required this.packagePrice,
    required this.discountPrice,
    required this.details,
    required this.labId,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    var detailsList = json['details'] as List;
    List<TestDetailModel> details =
    detailsList.map((i) => TestDetailModel.fromJson(i)).toList();

    return PackageModel(
      packageId: json['packageId'] ?? 0,
      packageName: json['packageName'] ?? 'N/A',
      packagePrice: json['packagePrice'] ?? 0,
      discountPrice: json['discountPrice'] ?? 0,
      details: details,
      labId: json['labId'] ?? 0,
    );
  }
}

class TestDetailModel {
  final int id;
  final int testId;
  final String testName;
  final double testPrice;

  TestDetailModel({
    required this.id,
    required this.testId,
    required this.testName,
    required this.testPrice,
  });

  factory TestDetailModel.fromJson(Map<String, dynamic> json) {
    return TestDetailModel(
      id: json['id'] ?? 0,
      testId: json['testId'] ?? 0,
      testName: json['testName'] ?? 'N/A',
      testPrice: json['testPrice'] ?? 0,
    );
  }
}