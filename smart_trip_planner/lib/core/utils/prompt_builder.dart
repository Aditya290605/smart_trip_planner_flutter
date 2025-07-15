class PromptBuilder {
  static String build({
    required String userRequest,
    required String previousJson,
    required List<Map<String, String?>> chatHistory,
  }) {
    final history = chatHistory
        .map((e) => "${e['role']}: ${e['content']}")
        .join("\n");

    return """
You are a travel assistant. Validate all places via Google Search before responding.
Request: $userRequest
Previous JSON:
$previousJson

Chat History:
$history

Return response strictly in this format:
{
  "title": "...",
  "startDate": "YYYY-MM-DD",
  "endDate": "YYYY-MM-DD",
  "days": [
    {
      "date": "YYYY-MM-DD",
      "summary": "...",
      "items": [
        {"time": "HH:MM", "activity": "...", "location": "lat,lng"}
      ]
    }
  ]
}
""";
  }
}
