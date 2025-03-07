// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final List<User> _users = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final ApiService _apiService;
  static const int _maxUsers = 10; // Maximum number of users from JSONPlaceholder

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  UserProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<void> fetchUsers() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      //Keep fetching until we have at least _minUsersToDisplay or no more users are available
      final newUsers = await _apiService.fetchUsers(_page);
      _users.addAll(newUsers); // Add users first
      if (newUsers.isEmpty || _users.length >= _maxUsers) {
        _hasMore = false; // Disable when no more users or max reached
      } else {
        _page++; //move to next page
      }
    } catch (e) {
      debugPrint('Error fetching users: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
