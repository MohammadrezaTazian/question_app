import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:question_app/models/year.dart';

class YearService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<List<Year>> getYears() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/years'),
        headers: {'Accept': 'application/json; charset=utf-8'},
      );
      
      if (response.statusCode == 200) {
        // Use utf8.decode to properly decode the response body
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> yearsJson = json.decode(decodedBody);
        return yearsJson.map((json) => Year.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load years: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching years: $e');
    }
  }
}