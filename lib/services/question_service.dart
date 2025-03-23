import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:question_app/models/question.dart';

class QuestionService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<List<Question>> getQuestionsByCourse(String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/questions?courseId=$courseId'),
        headers: {'Accept': 'application/json; charset=utf-8'},
      );
      
      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> questionsJson = json.decode(decodedBody);
        return questionsJson.map((json) => Question.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
}