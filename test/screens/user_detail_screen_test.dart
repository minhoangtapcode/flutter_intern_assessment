import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_intern_assessment/models/user.dart';
import 'package:flutter_intern_assessment/screens/user_detail_screen.dart';

void main() {
  final testUser = User(
    id: 1,
    name: 'User 0',
    username: 'user0',
    email: 'user0@example.com',
    phone: '123-456-7890',
    website: 'user0.com',
  );

  group('UserDetailScreen', () {
    testWidgets('should display user details correctly in standalone mode (phone)', (WidgetTester tester) async {
      // Act: Render the widget in standalone mode (isEmbedded: false)
      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailScreen(user: testUser),
        ),
      );
      await tester.pumpAndSettle();

      // Assert: Check that all user details are displayed
      expect(find.text('User Details'), findsOneWidget); // AppBar title
      expect(find.text('ID:'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Name:'), findsOneWidget);
      expect(find.text('User 0'), findsOneWidget);
      expect(find.text('Username:'), findsOneWidget);
      expect(find.text('user0'), findsOneWidget);
      expect(find.text('Email:'), findsOneWidget);
      expect(find.text('user0@example.com'), findsOneWidget);
      expect(find.text('Phone:'), findsOneWidget);
      expect(find.text('123-456-7890'), findsOneWidget);
      expect(find.text('Website:'), findsOneWidget);
      expect(find.text('user0.com'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display user details correctly in embedded mode (tablet)', (WidgetTester tester) async {
      // Act: Render the widget in embedded mode (isEmbedded: true)
      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailScreen(user: testUser, isEmbedded: true),
        ),
      );
      await tester.pumpAndSettle();

      // Assert: Check that user details are displayed without a Scaffold/AppBar
      expect(find.text('User Details'), findsNothing); // No AppBar in embedded mode
      expect(find.text('ID:'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Name:'), findsOneWidget);
      expect(find.text('User 0'), findsOneWidget);
      expect(find.text('Username:'), findsOneWidget);
      expect(find.text('user0'), findsOneWidget);
      expect(find.text('Email:'), findsOneWidget);
      expect(find.text('user0@example.com'), findsOneWidget);
      expect(find.text('Phone:'), findsOneWidget);
      expect(find.text('123-456-7890'), findsOneWidget);
      expect(find.text('Website:'), findsOneWidget);
      expect(find.text('user0.com'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}