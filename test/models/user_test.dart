import 'package:flutter_intern_assessment/models/user.dart';
import 'package:test/test.dart';

void main() {
  test('User.fromJson parses JSON correctly', () {
    final json = {
      'id': 1,
      'name': 'Leanne Graham',
      'username': 'Bret',
      'email': 'Sincere@april.biz',
      'address': {
        'street': 'Kulas Light',
        'suite': 'Apt. 556',
        'city': 'Gwenborough',
        'zipcode': '92998-3874',
        'geo': {'lat': '-37.3159', 'lng': '81.1496'},
      },
    };
    final user = User.fromJson(json);

    expect(user.id, 1);
    expect(user.name, 'Leanne Graham');
    expect(user.username, 'Bret');
    expect(user.email, 'Sincere@april.biz');
    expect(user.address.street, 'Kulas Light');
    expect(user.address.suite, 'Apt. 556');
  });
}
