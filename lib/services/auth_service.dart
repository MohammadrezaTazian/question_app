import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost:3000';
  
  // Login method
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users?username=$username&password=$password'),
    );
    
    if (response.statusCode == 200) {
      final users = jsonDecode(response.body);
      if (users.isNotEmpty) {
        return users[0];
      } else {
        throw Exception('Invalid username or password');
      }
    } else {
      throw Exception('Failed to login');
    }
  }
  
  // Register method
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    // First check if username exists
    final checkResponse = await http.get(
      Uri.parse('$baseUrl/users?username=$username'),
    );
    
    if (checkResponse.statusCode == 200) {
      final users = jsonDecode(checkResponse.body);
      if (users.isNotEmpty) {
        throw Exception('Username already exists');
      }
    }
    
    // Create new user
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }
}