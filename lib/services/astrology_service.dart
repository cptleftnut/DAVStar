import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AstrologyService {
  final _storage = const FlutterSecureStorage();
  static const String baseUrl = 'https://json.freeastrologyapi.com';

  Future<String?> _getApiKey() async => await _storage.read(key: 'freeastro_api_key');

  Future<Map<String, dynamic>?> fetchPlanets({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
  }) async {
    final apiKey = await _getApiKey();
    if (apiKey == null || apiKey.isEmpty) throw Exception('FreeAstroAPI-nøgle mangler');

    final dateParts = date.split('.');
    final timeParts = time.split(':');

    final response = await http.post(
      Uri.parse('$baseUrl/western/planets'),
      headers: {'x-api-key': apiKey, 'Content-Type': 'application/json'},
      body: jsonEncode({
        "year": int.parse(dateParts[2]),
        "month": int.parse(dateParts[1]),
        "date": int.parse(dateParts[0]),
        "hour": int.parse(timeParts[0]),
        "minute": int.parse(timeParts[1]),
        "latitude": latitude,
        "longitude": longitude,
        "timezone": 1.0,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('API-fejl: ${response.statusCode}');
  }
}
