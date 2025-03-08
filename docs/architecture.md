# Architecture Overview

## State Management Choice
### Choice: Provider
The app uses the `Provider` package for state management, implemented with `ChangeNotifierProvider` and `Consumer`. This choice was made for the following reasons:
- **Simplicity**: `Provider` is lightweight and straightforward, making it suitable for this small-scale app that manages a list of users and their loading state.
- **Reactiveness**: It leverages Flutter’s `ChangeNotifier` to efficiently update the UI when the user list or loading state changes, ensuring a smooth user experience.
- **Scalability**: While the app is currently simple, `Provider` can scale to larger applications by adding more providers or combining with other state management solutions if needed.
- **Community Support**: `Provider` is widely adopted in the Flutter community and recommended by the Flutter team, ensuring long-term support and compatibility.

### Implementation
- **UserProvider**: A `ChangeNotifier` class that manages the app’s state, including the list of users `(_users)`, loading state `(_isLoading)`, error state `(_hasError)`, pagination `(_currentPage)`, and whether more users can be fetched `(_hasMore)`. It uses the `ApiService` to fetch users from JSONPlaceholder and notifies listeners to update the UI when the state changes.
- **Usage**: The `UserProvider` is provided at the app’s root using `ChangeNotifierProvider` in `main.dart`, and `UserListScreen` consumes it with `Consumer<UserProvider>` to rebuild the UI when the user list or loading state updates.

## Testing Strategy(Didn't learn this before so get help by AI)
The app employs a robust testing strategy to ensure reliability and correctness across data, logic, and UI layers.

### Unit Tests
- **Purpose**: Validate the core data models and business logic.
- **Files**:
  - `test/models/user_test.dart`: Tests the `User` model’s serialization (`toJson`) and deserialization (`fromJson`) to ensure data integrity when parsing API responses.
  - `test/providers/user_provider_test.dart`: Tests the `UserProvider`’s `fetchUsers` method, verifying user fetching, loading states, and pagination logic (`hasMore`).
- **Tools**: Uses `flutter_test` and `mockito` to mock `ApiService` for isolated testing.

### Widget Tests(Test stuck at fetching more user)
- **Purpose**: Verify the UI behavior of the app’s main screens across different scenarios.
- **Files**:
  - `test/user_list_screen_test.dart`: Tests `UserListScreen` for loading states, user list display, "Load More" functionality, navigation, tablet layout, and empty state handling.
  - `test/user_detail_screen_test.dart`: Tests `UserDetailScreen` in both phone and embedded (tablet) layouts, ensuring user details are displayed correctly and image loading errors are handled with a fallback avatar.
- **Tools**: Uses `flutter_test` and `mockito` to mock `HttpClient` for network requests, with `HttpOverrides` to ensure all network calls are intercepted.

### Challenges and Solutions
- About the flutter test, i need help from the AI because I don't study about it, will learn in the future
- **Network Mocking**: Mocking `HttpClient` was challenging due to type mismatches (`Null` vs. `Future<HttpClientRequest>`). This was resolved by using specific `Uri` mocks and a default fallback for unhandled `Uri`s, combined with global `HttpOverrides`.
- **Mock Generation**: `mockito` required `build_runner` to generate mocks (e.g., `MockApiService`), ensuring proper testing of dependencies.

### Future Improvements
- Get knowledge about Flutter Test
- **Code Coverage**: Use `flutter test --coverage` to measure and improve test coverage.