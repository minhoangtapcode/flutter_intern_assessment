import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_intern_assessment/models/user.dart';

void main() {
  group('User Model', () {
    test('should correctly deserialize JSON to User', () {
      // Arrange: Sample JSON data from JSONPlaceholder
      final json = {
        'id': 1,
        'name': 'Leanne Graham',
        'username': 'Bret',
        'email': 'Sincere@april.biz',
        'phone': '1-770-736-8031 x56442',
        'website': 'hildegard.org',
      };

      // Act: Convert JSON to User
      final user = User.fromJson(json);

      // Assert: Check if the User object has the correct values
      expect(user.id, 1);
      expect(user.name, 'Leanne Graham');
      expect(user.username, 'Bret');
      expect(user.email, 'Sincere@april.biz');
      expect(user.phone, '1-770-736-8031 x56442');
      expect(user.website, 'hildegard.org');
    });

    test('should correctly serialize User to JSON', () {
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

      // Assert: Check if the JSON has the correct values
      expect(json['id'], 1);
      expect(json['name'], 'Leanne Graham');
      expect(json['username'], 'Bret');
      expect(json['email'], 'Sincere@april.biz');
      expect(json['phone'], '1-770-736-8031 x56442');
      expect(json['website'], 'hildegard.org');
    });
  });
}