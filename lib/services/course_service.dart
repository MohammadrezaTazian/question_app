import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:question_app/models/course.dart';

class CourseService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courses'),
        headers: {'Accept': 'application/json; charset=utf-8'},
      );
      
      if (response.statusCode == 200) {
        // Use utf8.decode to properly decode the response body
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> coursesJson = json.decode(decodedBody);
        return coursesJson.map((json) => Course.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }
}