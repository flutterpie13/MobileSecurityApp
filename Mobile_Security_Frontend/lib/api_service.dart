import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> scanUrl(String url, List<String> checks) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url, 'checks': checks}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Scan failed: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> getHistory() async {
    final response = await http.get(Uri.parse('$baseUrl/history'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch history: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Registration failed: ${response.reasonPhrase}');
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password'),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'oldPassword': oldPassword, 'newPassword': newPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteAccount() async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete-account'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> performCheck(
    String scanType,
    String target,
    String check,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/perform-check'),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'scanType': scanType, 'target': target, 'check': check}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Check failed: ${response.reasonPhrase}');
    }
  }
}
