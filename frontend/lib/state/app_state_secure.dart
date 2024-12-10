
import 'package:flutter/material.dart';
import '../secure_storage/secure_storage_service.dart';

class AppState extends ChangeNotifier {
  final SecureStorageService _secureStorage = SecureStorageService();

  String? _userEmail;

  String? get userEmail => _userEmail;

  Future<void> setUserEmail(String email) async {
    _userEmail = email;
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.saveToken('auth_token', token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.getToken('auth_token');
  }

  Future<void> deleteToken() async {
    await _secureStorage.deleteToken('auth_token');
  }
}
