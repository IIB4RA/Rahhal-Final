import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000"; // لو Emulator

  static Future<List<dynamic>> fetchLocations() async {
    final response = await http.get(Uri.parse('$baseUrl/locations'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load locations');
    }
  }

  static Future<void> addLocation(String name, double lat, double lng) async {
    final response = await http.post(
      Uri.parse('$baseUrl/locations'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "latitude": lat,
        "longitude": lng,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add location');
    }
  }
}