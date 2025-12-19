// file: lib/models/test_search_model.dart

/// Represents a single test result item from the search API.
class TestSearchModel {
  final int id;
  final String name;
  final int groupType;

  TestSearchModel({
    required this.id,
    required this.name,
    required this.groupType,
  });

  factory TestSearchModel.fromJson(Map<String, dynamic> json) {
    return TestSearchModel(
      id: json['id'] as int,
      name: json['name'] as String,
      groupType: json['groupType'] as int,
    );
  }

  // Helper method for logging/debugging
  @override
  String toString() {
    return 'TestSearchModel(id: $id, name: $name, groupType: $groupType)';
  }
}