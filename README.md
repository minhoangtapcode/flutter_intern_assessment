# Flutter Intern Assessment 

A Flutter application that fetches a list of users from a public API, displays them in a list, and provides detailed views for each user. The app supports both phone and tablet layouts.

## Getting Started

### Prerequisites
- **Flutter SDK**: Ensure Flutter is installed. Follow the [official installation guide](https://flutter.dev/docs/get-started/install) if needed.
- **Dart SDK**: Comes bundled with Flutter (version >=2.18.0 <3.0.0).
- **IDE**: Android Studio, Visual Studio Code, or any IDE with Flutter support.
- **Git**: Required to clone the repository.

### Installation
1. **Clone the Repository**:
   ```bash
   'git clone https://github.com/minhoangtapcode/flutter_intern_assessment.git'
   'cd flutter_intern_assessment'

2. **Install Dependencies**
    ```bash
    'flutter pub get'

3. **Generate Mocks for Tests**
    The app uses mockito for testing, which requires mock generation:
    ```bash
    'flutter pub run build_runner build --delete-conflicting-outputs'

4. **Run the Application**
    Connect a device (emulator or physical) or start an emulator (e.g., flutter emulators --launch apple_ios_simulator for iOS or use an Android emulator):
    ```bash
    'flutter run'
    The app will fetch users from the JSONPlaceholder API and display them in a list. Tap a user to view details, and use the "Load More" button to fetch additional users.

5. **Running test**
    ```bash
    'flutter test'

6. **Public APIs Used**
    The app fetches data from the following public APIs:
    JSONPlaceholder API:
        Base URL: https://jsonplaceholder.typicode.com
        Endpoint: /users?_page=<page>&_limit=<limit>
        Documentation: JSONPlaceholder
    Picsum Photos:
        URL: https://picsum.photos/50
        Documentation: Picsum Photos