//ignore: unused_import
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_intern_assessment/models/user.dart';
import 'package:flutter_intern_assessment/providers/user_provider.dart';
import 'package:flutter_intern_assessment/services/api_service.dart';
import '../mocks.mocks.dart';

void main() {
  late UserProvider userProvider;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    userProvider = UserProvider(apiService: mockApiService);
  });

  group('UserProvider', () {
    test('fetchUsers should load at least 6 users initially', () async {
      // Arrange: Mock the API service to return 6 users per page
      final firstPage = List.generate(
        6,
        (index) => User(
          id: index + 1,
          name: 'User $index',
          username: 'user$index',
          email: 'user$index@example.com',
          phone: '123-456-789$index',
          website: 'user$index.com',
        ),
      );

      when(mockApiService.fetchUsers(1, perPage: 6))
          .thenAnswer((_) async => firstPage);
      when(mockApiService.fetchUsers(2, perPage: 6))
          .thenAnswer((_) async => []); // Simulate no more users

      // Act: Call fetchUsers
      await userProvider.fetchUsers();

      // Assert: Check that exactly 6 users are loaded
      expect(userProvider.users.length, 6);
      expect(userProvider.users[0].name, 'User 0');
      expect(userProvider.users[5].name, 'User 5');
      expect(userProvider.isLoading, false);
      expect(userProvider.hasMore, false); // No more users to fetch
    });

    test('fetchUsers should stop when max users are reached', () async {
      // Arrange: Mock the API service to return 10 users across two pages
      final firstPage = List.generate(
        6,
        (index) => User(
          id: index + 1,
          name: 'User $index',
          username: 'user$index',
          email: 'user$index@example.com',
          phone: '123-456-789$index',
          website: 'user$index.com',
        ),
      );
      final secondPage = List.generate(
        4,
        (index) => User(
          id: index + 7,
          name: 'User ${index + 6}',
          username: 'user${index + 6}',
          email: 'user${index + 6}@example.com',
          phone: '123-456-789${index + 6}',
          website: 'user${index + 6}.com',
        ),
      );

      when(mockApiService.fetchUsers(1, perPage: 6))
          .thenAnswer((_) async => firstPage);
      when(mockApiService.fetchUsers(2, perPage: 6))
          .thenAnswer((_) async => secondPage);

      // Act: Call fetchUsers twice to simulate loading all users
      await userProvider.fetchUsers(); // First 6 users
      await userProvider.fetchUsers(); // Next 4 users

      // Assert: Check that exactly 10 users are loaded (maxUsers limit)
      expect(userProvider.users.length, 10);
      expect(userProvider.hasMore, false); // No more users to fetch
    });

    test('fetchUsers should handle errors gracefully', () async {
      // Arrange: Mock the API service to throw an error
      when(mockApiService.fetchUsers(1, perPage: 6))
          .thenThrow(Exception('Failed to fetch'));

      // Act: Call fetchUsers
      await userProvider.fetchUsers();

      // Assert: Check that no users are loaded and loading is false
      expect(userProvider.users.isEmpty, true);
      expect(userProvider.isLoading, false);
    });
  });
}
