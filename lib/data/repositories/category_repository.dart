import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/CategoryM/categoty_model.dart';

class CategoryRepository {
  final String baseUrl = "https://www.online-tech.in/api";

  Future<List<CategoryModelMain>> fetchCategories() async {
    final uri = Uri.parse("$baseUrl/MasterAPI/GetCategories");
    print("👉 API URL: $uri");

    final response = await http.get(uri);
    print("👉 Status Code: ${response.statusCode}");
    print("👉 Raw Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => CategoryModelMain.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load categories: ${response.statusCode}");
    }
  }
}
