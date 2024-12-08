import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> communicateWithBackend(String url) async {
  try {
    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Request timed out.');
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Success: $data');
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
