import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:question_app/models/field.dart';

class FieldService {
  final String baseUrl = 'http://localhost:3000';
  
  Future<List<Field>> getFields() async {
    final response = await http.get(
      Uri.parse('$baseUrl/fields'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    
    if (response.statusCode == 200) {
      // Properly decode the response with UTF-8
      final String decodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonData = jsonDecode(decodedBody);
      return jsonData.map((json) => Field.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load fields');
    }
  }
}