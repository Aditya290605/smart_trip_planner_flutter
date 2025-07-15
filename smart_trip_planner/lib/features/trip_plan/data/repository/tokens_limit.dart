class GeminiUsageTracker {
  static final GeminiUsageTracker _instance = GeminiUsageTracker._internal();
  factory GeminiUsageTracker() => _instance;
  GeminiUsageTracker._internal();

  int _requestTokens = 0;
  int _responseTokens = 0;
  int _failureCount = 0;

  int get requestTokens => _requestTokens;
  int get responseTokens => _responseTokens;
  int get failureCount => _failureCount;

  void track({
    required String prompt,
    required String response,
    bool failed = false,
  }) {
    if (failed) {
      _failureCount++;
      return;
    }

    final promptTokens = _estimateTokens(prompt);
    final responseTokens = _estimateTokens(response);

    _requestTokens += promptTokens;
    _responseTokens += responseTokens;
  }

  void reset() {
    _requestTokens = 0;
    _responseTokens = 0;
    _failureCount = 0;
  }

  int _estimateTokens(String text) {
    return (text.length / 4).ceil(); // Rough estimate
  }

  // If using Hive or SharedPreferences, add save/load methods here.
}
