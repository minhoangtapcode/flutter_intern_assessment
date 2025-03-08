import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  bool _hasError = false;
  int _currentPage = 1;
  bool _hasMore = true;

  final ApiService _apiService;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasMore => _hasMore;

  UserProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

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

  void reset() {
    _users.clear();
    _currentPage = 1;
    _hasMore = true;
    _hasError = false;
    _isLoading = false;
    notifyListeners();
  }
}
