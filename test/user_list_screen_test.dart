// test/user_list_screen_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_intern_assessment/models/user.dart';
import 'package:flutter_intern_assessment/providers/user_provider.dart';
import 'package:flutter_intern_assessment/screens/user_detail_screen.dart';
import 'package:flutter_intern_assessment/screens/user_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'mocks.mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}

class MyHttpOverrides extends HttpOverrides {
  final MockHttpClient mockHttpClient;

  MyHttpOverrides(this.mockHttpClient);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return mockHttpClient;
  }
}

void main() {
  late MockApiService mockApiService;
  late MockHttpClient mockHttpClient;
  late MockHttpHeaders mockHttpHeaders;

  setUp(() {
    mockApiService = MockApiService();
    mockHttpClient = MockHttpClient();
    mockHttpHeaders = MockHttpHeaders();

    // Mock HTTP client for API requests (first page)
    when(mockHttpClient.getUrl(Uri.parse('https://jsonplaceholder.typicode.com/users?_page=1&_limit=5'))).thenAnswer((invocation) async {
      debugPrint('Mocked API request for: ${invocation.positionalArguments[0]}');
      final request = MockHttpClientRequest();
      when(request.close()).thenAnswer((_) async {
        final response = MockHttpClientResponse();
        when(response.statusCode).thenReturn(200);
        when(response.contentLength).thenReturn(100);
        when(response.headers).thenReturn(mockHttpHeaders);
        final usersJson = jsonEncode([
          {
            "id": 1,
            "name": "Test User",
            "username": "testuser",
            "email": "test@example.com",
            "phone": "123-456-7890",
            "website": "test.com"
          }
        ]);
        when(response.transform(utf8.decoder)).thenAnswer((_) => Stream.value(usersJson));
        return response;
      });
      return Future.value(request);
    });

    // Mock HTTP client for API requests (second page)
    when(mockHttpClient.getUrl(Uri.parse('https://jsonplaceholder.typicode.com/users?_page=2&_limit=5'))).thenAnswer((invocation) async {
      debugPrint('Mocked API request for: ${invocation.positionalArguments[0]}');
      final request = MockHttpClientRequest();
      when(request.close()).thenAnswer((_) async {
        final response = MockHttpClientResponse();
        when(response.statusCode).thenReturn(200);
        when(response.contentLength).thenReturn(0);
        when(response.headers).thenReturn(mockHttpHeaders);
        when(response.transform(utf8.decoder)).thenAnswer((_) => Stream.value('[]')); // Empty list
        return response;
      });
      return Future.value(request);
    });

    // Mock HTTP client for image requests
    when(mockHttpClient.getUrl(Uri.parse('https://picsum.photos/50'))).thenAnswer((invocation) async {
      debugPrint('Mocked image request for: ${invocation.positionalArguments[0]}');
      final request = MockHttpClientRequest();
      when(request.close()).thenAnswer((_) async {
        final response = MockHttpClientResponse();
        when(response.statusCode).thenReturn(200);
        when(response.contentLength).thenReturn(100);
        when(response.headers).thenReturn(mockHttpHeaders);
        return response;
      });
      return Future.value(request);
    });

    // Default mock for any other Uri to prevent null returns
    when(mockHttpClient.getUrl(anyThat(isA<Uri>()))).thenAnswer((invocation) async {
      debugPrint('Default mock for unhandled Uri: ${invocation.positionalArguments[0]}');
      final request = MockHttpClientRequest();
      when(request.close()).thenAnswer((_) async {
        final response = MockHttpClientResponse();
        when(response.statusCode).thenReturn(200);
        when(response.contentLength).thenReturn(0);
        when(response.headers).thenReturn(mockHttpHeaders);
        return response;
      });
      return Future.value(request);
    });

    // Override global HttpClient
    HttpOverrides.global = MyHttpOverrides(mockHttpClient);
  });

  tearDown(() {
    HttpOverrides.global = null; // Reset after test
  });

  testWidgets('UserListScreen shows loading indicator initially and then users with Load More button', (WidgetTester tester) async {
    // Arrange: Create a UserProvider with the mocked service
    final provider = UserProvider(apiService: mockApiService);

    // Act: Pump the widget with the provider (phone layout by default)
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => provider,
        child: MaterialApp(
          home: const UserListScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == '/userDetail') {
              final user = settings.arguments as User;
              return MaterialPageRoute(
                builder: (context) => UserDetailScreen(user: user),
              );
            }
            return null;
          },
        ),
      ),
    );

    // Wait for the first frame to ensure the addPostFrameCallback fires
    await tester.pump();

    // Assert: Check for loading indicator initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Test User'), findsNothing);
    expect(find.byType(ElevatedButton), findsNothing);

    // Wait for the fetchUsers() to complete
    await tester.pumpAndSettle();

    // Assert: Check if the user name appears, loading is gone, and Load More button is visible
    expect(find.text('Test User'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.widgetWithText(ElevatedButton, 'Load More'), findsOneWidget);

    // Simulate another load (mock no more data)
    await tester.tap(find.widgetWithText(ElevatedButton, 'Load More'));
    await tester.pumpAndSettle();

    // Assert: Button should be gone if no more data
    expect(find.widgetWithText(ElevatedButton, 'Load More'), findsNothing);
    expect(find.text('No more users'), findsOneWidget);

    // Test navigation on phone (tap to navigate to detail screen)
    await tester.tap(find.text('Test User'));
    await tester.pumpAndSettle();
    expect(find.byType(UserDetailScreen), findsOneWidget);
    expect(find.text('Test User'), findsNWidgets(2)); // One in list, one in details

    // Navigate back to the list screen
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Test tablet layout
    tester.view.physicalSize = const Size(1280, 800); // Simulate tablet
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset); // Reset view settings after test
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => provider,
        child: const MaterialApp(home: UserListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Assert: Check for two-column layout
    expect(find.byType(Row), findsOneWidget);
    expect(find.text('Select a user to see details'), findsOneWidget);

    // Tap a user to show details in tablet layout
    await tester.tap(find.text('Test User'));
    await tester.pumpAndSettle();
    expect(find.text('Test User'), findsNWidgets(2)); // One in list, one in details
  });
}