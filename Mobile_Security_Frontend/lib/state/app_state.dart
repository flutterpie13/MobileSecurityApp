import 'package:flutter/material.dart';
import '../secure_storage/token_manager.dart';

class AppState extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<void> setToken(String token) async {
    _token = token;
    final tokenManager = TokenManager();
    await tokenManager.saveToken(token);
    notifyListeners();
  }

  Future<void> clearToken() async {
    _token = null;
    final tokenManager = TokenManager();
    await tokenManager.deleteToken();
    notifyListeners();
  }

  Future<void> loadToken() async {
    final tokenManager = TokenManager();
    _token = await tokenManager.loadToken();
    notifyListeners();
  }
}
