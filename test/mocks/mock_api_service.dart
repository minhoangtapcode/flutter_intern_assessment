// test/mocks/mock_api_service.dart
import 'package:flutter_intern_assessment/models/user.dart';
import 'package:flutter_intern_assessment/services/api_service.dart';
import 'package:mockito/mockito.dart';

class MockApiService extends Mock implements ApiService {
  @override
  Future<List<User>> fetchUsers(int page) async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate a response with 5 users for page 1
    return List.generate(5, (index) {
      return User(
        id: index + 1,
        name: 'Test User $index',
        username: 'user$index',
        email: 'user$index@example.com',
      );
    });
  }
}