import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class GeminiAdvisorService {
  /// Place your Google Gemini API Key here.
  /// The client can easily swap this key for their own free-tier key.
  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Analyzes the room image and returns a list of color combinations.
  /// Each combination has: primaryName, primaryHex, secondaryName, secondaryHex, reason.
  static Future<List<Map<String, dynamic>>> getPaintRecommendations(
      Uint8List imageBytes) async {
    // If no key is set, we throw a descriptive message so the client knows how to configure it.
    if (_apiKey.isEmpty) {
      throw Exception(
        'Gemini API Key is not configured.\n\nPlease define it using --dart-define=GEMINI_API_KEY=your_key or set it in gemini_advisor_service.dart.',
      );
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey',
    );

    final base64Image = base64Encode(imageBytes);

    final requestBody = {
      'contents': [
        {
          'parts': [
            {
              'text': 'Analyze this room photo. Identify its layout, lighting, floors, and furniture. '
                  'Suggest 3 color combinations from a paint store catalogue that would match beautifully. '
                  'Provide the response strictly in JSON format as a list of recommendation objects. '
                  'Each recommendation must contain exactly these 5 keys: \n'
                  '- "primaryName": name of the main wall color (e.g. Ocean Breeze)\n'
                  '- "primaryHex": hex code of main color (e.g. #D4E6F1)\n'
                  '- "secondaryName": name of the accent/corridor color (e.g. Shell White)\n'
                  '- "secondaryHex": hex code of accent color (e.g. #FDFEFE)\n'
                  '- "reason": one sentence explaining why this matches the room style, floor, and lighting.'
            },
            {
              'inlineData': {
                'mimeType': 'image/jpeg',
                'data': base64Image,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
      }
    };

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          throw Exception('No recommendations returned from Gemini.');
        }

        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;
        if (parts == null || parts.isEmpty) {
          throw Exception('Invalid response content parts.');
        }

        final rawText = parts[0]['text'] as String?;
        if (rawText == null || rawText.trim().isEmpty) {
          throw Exception('Empty text response from Gemini.');
        }

        final cleanedText = rawText.trim();
        final decodedList = jsonDecode(cleanedText);
        if (decodedList is List) {
          return decodedList
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        } else {
          throw Exception('Expected a JSON list of recommendations.');
        }
      } else {
        // Detailed error for client configuration debugging
        final errBody = response.body;
        if (response.statusCode == 400 &&
            errBody.contains('API key not valid')) {
          throw Exception('Invalid Gemini API Key. Please verify your key.');
        }
        throw Exception(
            'Gemini API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Catch network or formatting exceptions and rethrow friendly messages
      if (e is http.ClientException ||
          e.toString().contains('SocketException')) {
        throw Exception(
            'Network error: Unable to connect to Gemini API. Please check your internet.');
      }
      rethrow;
    }
  }
}
