// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_intern_assessment/models/user.dart';
import 'package:flutter_intern_assessment/providers/user_provider.dart';
import 'package:flutter_intern_assessment/screens/user_list_screen.dart';
import 'package:flutter_intern_assessment/services/api_service.dart';
import '../mocks.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late UserProvider userProvider;

  setUp(() {
    mockApiService = MockApiService();
    userProvider = UserProvider(apiService: mockApiService);
  });

  // Helper method to wrap the widget with Provider
  Widget createWidgetUnderTest({double width = 400}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 800)),
        child: ChangeNotifierProvider<UserProvider>(
          create: (_) => userProvider,
          child: const UserListScreen(),
        ),
      ),
    );
  }

  group('UserListScreen', () {
    testWidgets('should display at least 6 users initially on phone layout',
        (WidgetTester tester) async {
      // Arrange: Mock the API to return 6 users
      final users = List.generate(
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
          .thenAnswer((_) async => users);

      // Act: Render the widget (phone layout, width < 600)
      await tester.pumpWidget(createWidgetUnderTest(width: 400));
      await tester.pumpAndSettle(); // Wait for initState to call fetchUsers

      // Assert: Check that 6 users are displayed
      expect(find.byType(ListTile), findsNWidgets(6));
      expect(find.text('User 0'), findsOneWidget);
      expect(find.text('User 5'), findsOneWidget);
    });

    testWidgets(
        'should display Load More button and fetch more users when pressed on phone layout',
        (WidgetTester tester) async {
      // Arrange: Mock the API to return users in two batches
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

      // Act: Render the widget and fetch the first page
      await tester.pumpWidget(createWidgetUnderTest(width: 400));
      await tester.pumpAndSettle();

      // Assert: Check that 6 users are displayed initially
      expect(find.byType(ListTile), findsNWidgets(6));

      // Act: Tap the Load More button to fetch the next page
      await tester.tap(find.text('Load More'));
      await tester.pumpAndSettle();

      // Assert: Check that 10 users are now displayed
      expect(find.byType(ListTile), findsNWidgets(10));
      expect(find.text('User 9'), findsOneWidget);
      expect(find.text('No more users'), findsOneWidget);
    });

    testWidgets(
        'should show loading indicator while fetching users on phone layout',
        (WidgetTester tester) async {
      // Arrange: Mock the API to return users after a delay
      when(mockApiService.fetchUsers(1, perPage: 6)).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 500));
        return [
          User(
            id: 1,
            name: 'User 0',
            username: 'user0',
            email: 'user0@example.com',
            phone: '123-456-7890',
            website: 'user0.com',
          ),
        ];
      });

      // Act: Render the widget and fetch users
      await tester.pumpWidget(createWidgetUnderTest(width: 400));
      await tester.pump(); // Start the loading state

      // Assert: Check that the loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Act: Wait for the fetch to complete
      await tester.pumpAndSettle(Duration(seconds: 1));

      // Assert: Check that the loading indicator is gone and users are displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets(
        'should display user details on tablet layout when a user is selected',
        (WidgetTester tester) async {
      // Arrange: Mock the API to return 6 users
      final users = List.generate(
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
          .thenAnswer((_) async => users);

      // Act: Render the widget (tablet layout, width > 600)
      await tester.pumpWidget(createWidgetUnderTest(width: 800));
      await tester.pumpAndSettle();

      // Assert: Initially, no user is selected, so the placeholder text is shown
      expect(find.text('Select a user to see details'), findsOneWidget);

      // Act: Tap on the first user to select them
      await tester.tap(find.text('User 0'));
      await tester.pumpAndSettle();

      // Assert: Check that the user details are displayed
      expect(find.text('User 0'),
          findsNWidgets(2)); // Once in list, once in details
      expect(find.text('user0'),
          findsNWidgets(2)); // Once in list, once in details
      expect(find.text('user0@example.com'), findsOneWidget);
    });
  });
}
