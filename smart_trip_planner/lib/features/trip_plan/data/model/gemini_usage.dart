class GeminiUsageStats {
  final int requestTokensUsed;
  final int responseTokensUsed;
  final double totalCostUsd;

  GeminiUsageStats({
    required this.requestTokensUsed,
    required this.responseTokensUsed,
    required this.totalCostUsd,
  });

  int get totalTokens => 1000; // Hardcoded limit for now

  double get requestProgress => requestTokensUsed / totalTokens;
  double get responseProgress => responseTokensUsed / totalTokens;
}
