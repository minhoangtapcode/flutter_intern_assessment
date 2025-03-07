// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const int perPage = 5; // Simulate pagination with 5 items per page

  Future<List<User>> fetchUsers(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users?_page=$page&_limit=$perPage'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
