import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      if (response.statusCode != 201) {
        // Handle error
        throw Exception('Failed to sign up');
      }
      final user = jsonDecode(response.body) as Map<String, dynamic>;
      return user;
    } catch (e) {
      print(e);
      throw Exception('Signup failed: $e');
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
