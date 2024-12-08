import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

Future<void> register(String email, String password) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/auth/register');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 201) {
    print('User registered successfully.');
  } else {
    throw Exception('Failed to register: ${response.body}');
  }
}

Future<void> login(String email, String password) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/auth/login');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    print('Login successful.');
  } else {
    throw Exception('Failed to login: ${response.body}');
  }
}
