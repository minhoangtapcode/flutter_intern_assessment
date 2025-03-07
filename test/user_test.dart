// test/models/user_test.dart
import 'package:flutter_intern_assessment/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Model Tests', () {
    test('should create a User from JSON', () {
      // Arrange: Sample JSON data from the API
      final json = {
        'id': 1,
        'name': 'Leanne Graham',
        'username': 'Bret',
        'email': 'Sincere@april.biz',
        'phone': '1-770-736-8031 x56442',
        'website': 'hildegard.org',
      };

      // Act: Deserialize JSON into a User object
      final user = User.fromJson(json);

      // Assert: Verify the User object fields
      expect(user.id, 1);
      expect(user.name, 'Leanne Graham');
      expect(user.username, 'Bret');
      expect(user.email, 'Sincere@april.biz');
      expect(user.phone, '1-770-736-8031 x56442');
      expect(user.website, 'hildegard.org');
    });

    test('should convert a User to JSON', () {
      // Arrange: Create a User object
      final user = User(
        id: 1,
        name: 'Leanne Graham',
        username: 'Bret',
        email: 'Sincere@april.biz',
        phone: '1-770-736-8031 x56442',
        website: 'hildegard.org',
      );

      // Act: Convert User to JSON
      final json = user.toJson();

      // Assert: Verify the JSON output
      expect(json['id'], 1);
      expect(json['name'], 'Leanne Graham');
      expect(json['username'], 'Bret');
      expect(json['email'], 'Sincere@april.biz');
      expect(json['phone'], '1-770-736-8031 x56442');
      expect(json['website'], 'hildegard.org');
    });

    test('should handle missing optional fields in JSON', () {
      // Arrange: JSON data with missing optional fields
      final json = {
        'id': 2,
        'name': 'Ervin Howell',
        'username': 'Antonette',
        'email': 'Shanna@melissa.tv',
      };

      // Act: Deserialize JSON into a User object
      final user = User.fromJson(json);

      // Assert: Verify the User object fields (missing fields should be null or empty)
      expect(user.id, 2);
      expect(user.name, 'Ervin Howell');
      expect(user.username, 'Antonette');
      expect(user.email, 'Shanna@melissa.tv');
      expect(user.phone, '');
      expect(user.website, '');
    });
  });
}