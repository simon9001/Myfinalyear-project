import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://backendar.onrender.com/api";

  // Fetch Programs
  static Future<List<dynamic>> fetchPrograms() async {
    final response = await http.get(Uri.parse("$baseUrl/programs/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load programs");
    }
  }

  // Fetch Courses
  static Future<List<dynamic>> fetchCourses() async {
    final response = await http.get(Uri.parse("$baseUrl/courses/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load courses");
    }
  }

  // Fetch Single Course
  static Future<Map<String, dynamic>> fetchCourseDetail(String slug) async {
    final response = await http.get(Uri.parse("$baseUrl/courses/$slug/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load course details");
    }
  }
}
