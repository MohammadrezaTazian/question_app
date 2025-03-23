import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';

class CommentService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Comment>> getCommentsByQuestionId(String questionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/comments?questionId=$questionId'),
        headers: {'Accept': 'application/json; charset=UTF-8'},
      );
      
      if (response.statusCode == 200) {
        // Properly decode the UTF-8 response
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  Future<Comment> addComment(Comment comment) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/comments'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8'
        },
        body: utf8.encode(json.encode(comment.toJson())),
      );
      
      if (response.statusCode == 201) {
        // Properly decode the UTF-8 response
        return Comment.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }
}