// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  bool _hasError = false;
  int _currentPage = 1;
  bool _hasMore = true;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasMore => _hasMore;

  final ApiService _apiService = ApiService();

  Future<void> fetchUsers() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      print('Fetching more users, page: $_currentPage');
      final newUsers = await _apiService.fetchUsers(_currentPage);
      if (newUsers.isEmpty) {
        _hasMore = false;
      } else {
        _users.addAll(newUsers);
        _currentPage++;
      }
      _hasError = false;
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
