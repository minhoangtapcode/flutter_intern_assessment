// lib/services/api_service.dart
import 'package:flutter_intern_assessment/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:mockito/annotations.dart'; 

@GenerateMocks([ApiService])
class ApiService {
  Future<List<User>> fetchUsers(int page, {int perPage = 6}) async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users?_page=$page&_limit=$perPage'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}