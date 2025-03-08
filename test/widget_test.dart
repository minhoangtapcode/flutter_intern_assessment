// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_intern_assessment/screens/user_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_intern_assessment/providers/user_provider.dart';
import 'mocks/mock_api_service.dart';

void main() {
  testWidgets('UserListScreen shows loading indicator initially',
      (WidgetTester tester) async {
    // Create a mock ApiService
    final mockApiService = MockApiService();

    // Build the widget tree with a mock UserProvider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(apiService: mockApiService)
              ..fetchUsers(), // Inject mock
          ),
        ],
        child: const MaterialApp(home: UserListScreen()),
      ),
    );

    // Wait for the initial frame to render
    await tester.pump();

    // Verify that the loading indicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate a delay to mimic the loading process (optional, if mock is instant)
    await Future.delayed(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Verify that the loading indicator is gone and the user list is displayed
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListTile), findsWidgets); // Check for user tiles
  });
}
