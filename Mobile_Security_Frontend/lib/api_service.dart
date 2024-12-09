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

  Future<Map<String, dynamic>> getData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // JSON parsen
        return {'data': response.body};
      } else {
        // Hier HTTP-Fehler behandeln
        throw Exception('Serverfehler: ${response.statusCode}');
      }
    } catch (e) {
      // Netzwerkfehler, DNS-Fehler etc.
      throw Exception('Netzwerkfehler: $e');
    }
  }

  Future<Map<String, String>> getScanResults(
      String scanType, String target) async {
    // Hier ein Beispiel-Endpunkt. Passe die URL an dein Backend an.
    final url =
        'https://dein-backend.com/scan_results?scanType=$scanType&target=$target';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // Gehe davon aus, dass decoded ein Map ist, die CheckName:Status enthält.
      // Eventuell brauchst du hier noch Konvertierungslogik.
      return Map<String, String>.from(decoded);
    } else {
      throw Exception(
          'Fehler beim Laden der Scan-Ergebnisse: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getCheckDetails(String checkName) async {
    // Passe die URL an dein Backend an:
    final url = 'http://localhost:5000/scan/details?checkName=$checkName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
      // Erwartet: { "status": "Pass", "recommendations": "..." }
    } else {
      throw Exception(
          'Fehler beim Laden der Detailinformationen: ${response.statusCode}');
    }
  }
}
