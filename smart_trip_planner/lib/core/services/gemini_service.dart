import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Main function to call your Firebase Gemini-powered Cloud Function
Future<Map<String, dynamic>?> fetchItineraryFromLLM({
  required String prompt,
  Map<String, dynamic>? previousItinerary,
  List<Map<String, String>>? chatHistory,
}) async {
  const String apiUrl =
      'https://us-central1-itinera-ai-3df91.cloudfunctions.net/api/generate-itinerary';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt': prompt,
        'previousItinerary': previousItinerary ?? {},
        'chatHistory': chatHistory ?? [],
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> itinerary = jsonDecode(response.body);
      // ✅ This should be in the Spec A format you showed
      return itinerary;
    } else {
      debugPrint(" Error: ${response.statusCode} - ${response.body}");
      return null;
    }
  } catch (e) {
    debugPrint(" Exception while calling itinerary API: $e");
    return null;
  }
}
