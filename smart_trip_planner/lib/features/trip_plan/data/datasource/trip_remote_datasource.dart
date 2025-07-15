import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class TripRemoteDatasource {
  Future<Map<String, dynamic>> callGeminiAPI(String prompt);
}

class TripRemoteDatasourceImpl implements TripRemoteDatasource {
  final String apiKey;
  TripRemoteDatasourceImpl(this.apiKey);

  @override
  Future<Map<String, dynamic>> callGeminiAPI(String prompt) async {
    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final content =
          jsonResponse['candidates'][0]['content']['parts'][0]['text'];

      final cleanedJsonString = _extractJsonFromText(content);
      return jsonDecode(cleanedJsonString);
    } else {
      throw Exception('Failed to fetch data: ${response.body}');
    }
  }

  String _extractJsonFromText(String content) {
    final startIndex = content.indexOf('{');
    final endIndex = content.lastIndexOf('}');
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return content.substring(startIndex, endIndex + 1);
    } else {
      throw FormatException('No valid JSON object found in Gemini response');
    }
  }
}
